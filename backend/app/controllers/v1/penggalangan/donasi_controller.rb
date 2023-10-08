class V1::Penggalangan::DonasiController < ApplicationController
    # before_action :
  def createDonasi
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    return render_error_response("Data Penggalangan Dana tidak ada!") unless penggalangan_dana
  
    pengajuan_bantuan = fetch_pengajuan_bantuan(penggalangan_dana.pengajuan_bantuan_id)
  
    return render_error_response("Penggalangan Dana tidak ada") unless pengajuan_bantuan
  
    data_donatur = User::Donatur.where(nomor_telepon: params[:nomor_telepon]).first
    donatur, is_struk_pembayaran = prepare_donatur_and_check_struk(data_donatur, pengajuan_bantuan)
  
    return render_error_response("Tidak dapat melakukan donasi, Upload struk pembayaran pada donasi sebelumnya!") if is_struk_pembayaran != 0
  
    nomor_referensi = generate_unique_nomor_referensi
    waktu_berakhir = Time.now + 1.hour
  
    donasi = build_donasi(donasi_params, waktu_berakhir, nomor_referensi)
    donasi.save
  
    penggalangan_dana.donasi_id.present? ? penggalangan_dana.donasi_id << donasi.id : penggalangan_dana.update(donasi_id: [donasi.id])
  
    donatur.donasi_id.present? ? donatur.donasi_id << donasi.id : donatur.update(donasi_id: [donasi.id])
    donatur.save(:validate => false)
  
    if donasi.save && penggalangan_dana.save
      render_success_response(Constants::RESPONSE_CREATED, {donasi: donasi, donatur: donatur, penggalangan_dana: penggalangan_dana, bank: donatur.bank}, Constants::STATUS_CREATED)
    else
      render_error_response({donasi: donasi.errors.full_messages, penggalangan_dana: penggalangan_dana.errors.full_messages})
    end
  end

  def getPendingDonasi
    donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
    return render_error_response("Data Donasi baru tidak ditemukan!") unless donasi
  
    status_donasi, durasi, waktu_berakhir = calculate_donasi_status_and_duration(donasi)
    
    render_success_response(Constants::RESPONSE_SUCCESS,{
      durasi: durasi, 
      waktu_berakhir: waktu_berakhir,
      status: status_donasi,
      jumlah_donasi: donasi.nominal,
      bank: V1::User::AdminController.new.getBankByAdmin(return_json: false)
      },
      Constants::STATUS_OK
    )
  end

  def uploadStrukPembayaran
    donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
    return render_error_response("Data Donasi baru tidak ditemukan!") unless donasi
  
    if params[:struk_pembayaran].blank?
      return render_error_response("Path struk pembayaran tidak boleh kosong!")
    end
  
    donasi.update(struk_pembayaran: params[:struk_pembayaran])
    
    render_success_response(Constants::RESPONSE_SUCCESS,donasi, Constants::STATUS_CREATED)
  end

  def approvalDonasi
    if params[:nomor_referensi].present?
      donasi = Penggalangan::Donasi.expired.where(nomor_referensi: params[:nomor_referensi]).first
      return render_error_response("Data Donasi Expired tidak ditemukan!") unless donasi
    else
      donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
      return render_error_response("Data Donasi baru tidak ditemukan!") unless donasi
      return render_error_response("Struk Pembayaran masih kosong!") if donasi.status == 0 && !donasi.struk_pembayaran.present?
    end
  
    if params[:is_approve].blank? || !["true", "false"].include?(params[:is_approve])
      return render_error_response("is_approve hanya dapat true atau false!")
    end
  
    penggalangan_dana = Penggalangan::PenggalanganDana.where(donasi_id: donasi.id).first
  
    if params[:is_approve] == "true"
      donasi_approved = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      total_nominal_awal = donasi_approved.present? ? donasi_approved.pluck(:nominal).inject(0, :+) : 0
      total_nominal_terkumpul = total_nominal_awal + donasi.nominal
      penggalangan_dana.assign_attributes(total_nominal_terkumpul: total_nominal_terkumpul)
      status_donasi = Enums::StatusDonasi::APPROVED
    else
      status_donasi = Enums::StatusDonasi::REJECTED
    end
  
    donatur = User::Donatur.where(donasi_id: donasi.id).first
    if donatur.status == false
      password_candidate = (0...8).map { (65 + rand(26)).chr }.join
      donatur.assign_attributes(
        password: password_candidate,
        password_confirmation: password_candidate,
        status: Enums::StatusDonatur::REGISTERED,
      )
      donatur.save!
    else
      password_candidate = []
    end
  
    donasi.assign_attributes(status: status_donasi)
  
    if donasi.save && penggalangan_dana&.save
      render_success_response(Constants::RESPONSE_SUCCESS, {
        penggalangan_dana: penggalangan_dana, 
        donatur: donatur, 
        donasi: donasi, 
        password_donatur: password_candidate 
      }, Constants::STATUS_OK)
    else
      render_error_response({donasi: donasi.errors.full_messages, penggalangan_dana: penggalangan_dana&.errors&.full_messages})
    end
  end

  def getDonasiByStatus
    status = params[:status].to_i
  
    if status.zero? || status == 4
      status_donasi = status.zero? ? "Baru" : "Kadaluwarsa"
      donasi = Penggalangan::Donasi.where(status: status)
  
      if donasi.present?
        array_of_data_donasi = donasi.map do |data_donation|
          penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id => data_donation.id).first
          donatur = User::Donatur.where(:donasi_id => data_donation.id).first
          pengajuan_bantuan = penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array) ?
                             Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id[0]).first :
                             Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id).first
  
          {
            pengajuan_bantuan_id: pengajuan_bantuan,
            donatur: {
			  donatur: donatur,
              donasi_id: data_donation,
              bank_id: Bank.where(id: donatur.bank_id).first
            }
          }
        end
  
        data_donasi = array_of_data_donasi.length > 1 ? array_of_data_donasi.reverse : array_of_data_donasi.first
        render_success_response(Constants::RESPONSE_SUCCESS, data_donasi, Constants::STATUS_OK)
      else
        render_error_response("Tidak ada data donasi #{status_donasi}!")
      end
    else
      render_error_response("Status #{status} tidak ada!, status hanya dapat 0 atau 4!")
    end
  end

  def getTotalNewDonasi
    donasi = Penggalangan::Donasi.new_donation
    if not donasi.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: 0
        }, status: :ok
    else
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: donasi.length
        }, status: :ok
    end
  end

  def getTotalAllDonasi
    donasi = Penggalangan::Donasi.approved
  
    if donasi.present?
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id.in => donasi.pluck(:id))
      array_of_nominal_donasi = []
      array_of_nominal_penyaluran = []
  
      penggalangan_dana.each do |data|
        if data.pengajuan_bantuan_id.kind_of?(Array)
          data.pengajuan_bantuan_id.each_with_index do |data_pengajuan_bantuan_id, index_pengajuan_bantuan_id|
            next if index_pengajuan_bantuan_id == 0
  
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: data_pengajuan_bantuan_id).first
            beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first
            array_of_nominal_penyaluran << beasiswa.nominal_penyaluran
          end
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.done.where(id: data.pengajuan_bantuan_id).first
          array_of_nominal_donasi << data.total_nominal_terkumpul if pengajuan_bantuan.present?
        end
      end
      total_donasi_terkumpul = donasi.pluck(:nominal).sum - (array_of_nominal_donasi.sum + array_of_nominal_penyaluran.sum)
      
      render_success_response(Constants::RESPONSE_SUCCESS, total_donasi_terkumpul, Constants::STATUS_OK)      
    else

      render json: {
        response_code: Constants::RESPONSE_SUCCESS,
        response_message: "Success",
        data: 0
      }, status: :ok
    end
  end

  def search
    donasi = Penggalangan::Donasi.all
    if params[:keyword].blank?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Nomor Referensi tidak boleh kosong!"
        }, status: :unprocessable_entity
    elsif not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada data donasi!"
        }, status: :unprocessable_entity
    else
      searched_donasi = donasi.select do | data | data.attributes.values.grep(/^#{params[:keyword]}/i).any? end
      if not donasi.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada data donasi berdasarkan keyword: #{params[:keyword]}!"
          }, status: :unprocessable_entity
      else
        penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id.in => searched_donasi.pluck(:id))
        donatur = User::Donatur.where(:donasi_id.in => searched_donasi.pluck(:id))
        if searched_donasi.length > 1
          array_of_data_donasi = []
          searched_donasi.each_with_index do |data_donation, index_donasi|
            penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id => data_donation.id).first
            donatur = User::Donatur.where(:donasi_id => data_donation.id).first
            if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
              pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id[0])
            else
              pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id)
            end
            object_data_donasi = penggalangan_dana.attributes.merge({
              :pengajuan_bantuan_id => pengajuan_bantuan.first,
              :donasi_id => donatur.attributes.merge(:donasi_id => data_donation)
            })
            object_data_donasi["donatur"] = object_data_donasi.delete("donasi_id")
            array_of_data_donasi << object_data_donasi
  
          end
          data_donasi = array_of_data_donasi.reverse
        else
          data_penggalangan_dana = penggalangan_dana.first
          if data_penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.first.pengajuan_bantuan_id[0])
          else
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.first.pengajuan_bantuan_id)
          end
          bank = Bank.where(:id => donatur.first.bank_id).first
          data_donasi = data_penggalangan_dana.attributes.merge({
            :pengajuan_bantuan_id => pengajuan_bantuan.first,
            :donasi_id => donatur.first.attributes.merge({
              :donasi_id => searched_donasi.first,
              :bank_id => bank
              })
          })
          data_donasi["donatur"] = data_donasi.delete("donasi_id")
        end
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: data_donasi
          }, status: :ok
      end
    end
  end

  private
  # Form Donasi
  def donasi_params
    params.permit(
      :nominal,
    )
  end

  def bank_params
    params.permit(:nama_bank, :nomor_rekening, :nama_pemilik_rekening)
  end

  def fetch_pengajuan_bantuan(pengajuan_bantuan_id)
    if pengajuan_bantuan_id.kind_of?(Array)
      Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: pengajuan_bantuan_id[0]).first
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: pengajuan_bantuan_id).first
      pengajuan_bantuan.jenis == "Beasiswa" ? Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: pengajuan_bantuan_id).first : pengajuan_bantuan
    end
  end
  
  def prepare_donatur_and_check_struk(data_donatur, pengajuan_bantuan)
    is_struk_pembayaran = 0
    if data_donatur.present?
      donatur = data_donatur
      donasi_donatur = Penggalangan::Donasi.new_donation.where(:id.in => data_donatur.donasi_id)
      if donasi_donatur.length > 1 && donasi_donatur.pluck(:struk_pembayaran).length > 1
        puts "masuk ga sih"
        is_struk_pembayaran = 1
      end
    else
      bank = Bank.create(bank_params)
      donatur = User::Donatur.create(
        bank: bank,
        nama: params[:nama],
        nomor_telepon: params[:nomor_telepon],
        status: Enums::StatusDonatur::CANDIDATE
      )
      donatur.save(:validate => false)
      is_struk_pembayaran = 0
    end
    [donatur, is_struk_pembayaran]
  end
  
  def generate_unique_nomor_referensi
    random_number = 6.times.map { 10 + Random.rand(11) }.join("")
    while Penggalangan::Donasi.where(nomor_referensi: random_number).exists?
      random_number = 6.times.map { 10 + Random.rand(11) }.join("")
    end
    random_number
  end
  
  def build_donasi(donasi_params, waktu_berakhir, nomor_referensi)
    Penggalangan::Donasi.new(donasi_params.merge({
      waktu_berakhir: waktu_berakhir,
      nomor_referensi: nomor_referensi, 
      status: Enums::StatusDonasi::NEW,
    }))
  end

  def calculate_donasi_status_and_duration(donasi)
    seconds_diff = (donasi.waktu_berakhir - Time.now).to_i.abs
  
    if not donasi.struk_pembayaran.present?
      status_donasi = Enums::StatusDonasi::NEW
      if seconds_diff < 1
        donasi.update(status: Enums::StatusDonasi::EXPIRED)
      end
    else
      status_donasi = Enums::StatusDonasi::DONE
    end
  
    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600
    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60
    seconds = seconds_diff
  
    durasi = "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
    waktu_berakhir = donasi.waktu_berakhir.strftime("%A, %d %B %Y %H:%M")
  
    [status_donasi, durasi, waktu_berakhir]
  end
end

class V1::Penggalangan::PenggalanganDanaController < ApplicationController
  # before_action :
  #Untuk membuat penggalangan dana beasiswa
  def createPenggalanganDanaBeasiswa
    date_now = DateTime.now
    first_day_of_month = Date.new(date_now.year, date_now.month, 1)
    start_of_week = first_day_of_month - first_day_of_month.wday
    week_number = (date_now - start_of_week).to_i / 7 + 1
  
    penggalangan_dana_beasiswa = Pengajuan::PengajuanBantuan.pengajuan_baru_admin
    if penggalangan_dana_beasiswa.present?
      return render_error_response("Penggalangan Dana Beasiswa sedang berlangsung!")
    elsif week_number != 1
      return render_error_response("Gagal membuat penggalangan dana Beasiswa karena sudah minggu ke #{week_number} di Bulan #{date_now.strftime("%B")}!")
    else
      data_admin = User::Admin.where(id: params[:id]).first
      bank = Bank.where(id: data_admin.bank_id).first
      nama = data_admin.nama
      nomor_telepon = data_admin.nomor_telepon
      no_identitas_pengaju = "-"
      dana_yang_dibutuhkan = 0
      status_pengajuan = Enums::StatusPengajuan::ADMIN
      status_penyaluran = Enums::StatusPenyaluran::NULL
      next_month = first_day_of_month.next_month(7)
      waktu_galang_dana = next_month - 1
  
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(
        bank: bank,
        jenis: "Beasiswa",
        nama: nama,
        no_identitas_pengaju: no_identitas_pengaju,
        no_telepon: nomor_telepon,
        waktu_galang_dana: waktu_galang_dana,
        judul_galang_dana: params[:judul_galang_dana],
        deskripsi: params[:deskripsi],
        dana_yang_dibutuhkan: dana_yang_dibutuhkan,
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran,
      )
  
      if pengajuan_bantuan.save
        penggalangan_dana = Penggalangan::PenggalanganDana.new(
          total_pengajuan: params[:total_pengajuan],
          total_nominal_terkumpul: 0,
          pengajuan_bantuan_id: [pengajuan_bantuan.id]
        )
  
        if penggalangan_dana.save
          response_data = {
            penggalangan_dana: penggalangan_dana,
            pengajuan_bantuan: pengajuan_bantuan
          }
          render_success_response(Constants::RESPONSE_CREATED, response_data, Constants::STATUS_CREATED)
        else
          render_error_response({ penggalangan_dana: penggalangan_dana.errors.full_messages })
        end
      else
        render_error_response({ pengajuan_bantuan: pengajuan_bantuan.errors.full_messages })
      end
    end
  end

  def createPenggalanganDanaNonBeasiswa
    total_pengajuan = 1
    total_nominal_terkumpul = 0
    waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
  
    if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
      return render_error_response("Tanggal harus lebih dari hari sekarang!")
    end
  
    penggalangan_dana = Penggalangan::PenggalanganDana.new(
      total_pengajuan: total_pengajuan,
      total_nominal_terkumpul: total_nominal_terkumpul
    )
  
    no_identitas_pengaju = "-"
    no_identitas_penerima = "-"
    bukti_butuh_bantuan = "-"
    status_pengajuan = Enums::StatusPengajuan::APPROVED
    status_penyaluran = Enums::StatusPenyaluran::NEW
  
    bank = Bank.new(bank_params)
    if bank.save
      non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
      non_beasiswa.assign_attributes({
        no_identitas_penerima: no_identitas_penerima,
        bukti_butuh_bantuan: bukti_butuh_bantuan
      })
  
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
      pengajuan_bantuan.assign_attributes({
        jenis: "NonBeasiswa",
        bank: bank,
        no_identitas_pengaju: no_identitas_pengaju,
        waktu_galang_dana: waktu_galang_dana,
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran,
        non_beasiswa: non_beasiswa,
        penggalangan_dana: [penggalangan_dana]
      })
  
      if penggalangan_dana.save && pengajuan_bantuan.save && non_beasiswa.save
        response_data = {
          penggalangan_dana: penggalangan_dana,
          pengajuan_bantuan: pengajuan_bantuan,
          non_beasiswa: non_beasiswa,
          bank: bank
        }
        render_success_response(Constants::RESPONSE_CREATED, response_data, Constants::STATUS_CREATED)
      else
        errors = {
          penggalangan_dana: penggalangan_dana.errors.full_messages,
          pengajuan_bantuan: pengajuan_bantuan.errors.full_messages,
          non_beasiswa: non_beasiswa.errors.full_messages
        }
        bank.destroy if bank.persisted? # Rollback bank creation if other saves fail
        render_error_response(errors)
      end
    else
      render_error_response({ bank: bank.errors.full_messages })
    end
  end

  def getAllPenggalanganDana
    penggalangan_dana_all = Penggalangan::PenggalanganDana.all
  
    if penggalangan_dana_all.empty?
      return render_error_response("Tidak ada Penggalangan Dana yang berlangsung")
    end
  
    list_data_penggalangan_dana = []
    penggalangan_dana_beasiswa = []
    penggalangan_dana_non_beasiswa = []
  
    penggalangan_dana_all.each do |data_penggalangan_dana|
      pengajuan_bantuan = find_pengajuan_bantuan_by_penggalangan_dana(data_penggalangan_dana)
  
      if pengajuan_bantuan
        data_penggalangan_dana_attributes = {
          pengajuan_bantuan_id: pengajuan_bantuan,
          durasi: getDurasiPenggalanganDana(data_penggalangan_dana.id),
          total_donatur: getTotalDonaturByPenggalanganDana(data_penggalangan_dana.id)
        }
  
        if pengajuan_bantuan.jenis == "Beasiswa"
          penggalangan_dana_beasiswa << data_penggalangan_dana.attributes.merge(data_penggalangan_dana_attributes)
        else
          penggalangan_dana_non_beasiswa << data_penggalangan_dana.attributes.merge(data_penggalangan_dana_attributes)
        end
      end
    end
  
    list_data_penggalangan_dana << penggalangan_dana_beasiswa
    list_data_penggalangan_dana << penggalangan_dana_non_beasiswa.reverse
  
    new_data_pengajuan = list_data_penggalangan_dana.flatten
  
    render_success_response(Constants::RESPONSE_SUCCESS, new_data_pengajuan, Constants::STATUS_OK)
  end

  def getDurasiPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
  
    pengajuan_bantuan_id = Array(penggalangan_dana.pengajuan_bantuan_id)
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: pengajuan_bantuan_id[0]).first
  
    end_date = pengajuan_bantuan.waktu_galang_dana.to_datetime
    durasi = (end_date - DateTime.now).to_i + 1
  
    if durasi < 1
      pengajuan_bantuan_id.each_with_index do |data, index|
        if index == 0
          pengajuan_bantuan_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: data).first
          pengajuan_bantuan_admin.assign_attributes(status_pengajuan: Enums::StatusPengajuan::DONE)
          pengajuan_bantuan_admin.save!
        end
  
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: data).first
        pengajuan_bantuan.assign_attributes(
          status_pengajuan: Enums::StatusPengajuan::DONE,
          status_penyaluran: Enums::StatusPenyaluran::PENDING
        )
        pengajuan_bantuan.save!
      end
    end
  
    durasi
  end

  def getPenggalanganDanaNonBeasiswaByKategori
    valid_categories = ["Medis", "Bencana", "Duka"]
    unless valid_categories.include?(params[:kategori])
      return render_error_response("Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis/Bencana/Duka")
    end
  
    pengajuan_penggalangan_dana = Pengajuan::PengajuanBantuan.penggalangan_dana.where(jenis: "NonBeasiswa").reverse
  
    if pengajuan_penggalangan_dana.empty?
      return render_error_response("Tidak ada Penggalangan Dana Non Beasiswa yang berlangsung")
    end
  
    non_beasiswa = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_penggalangan_dana.pluck(:non_beasiswa_id)).where(kategori: params[:kategori])
  
    if non_beasiswa.empty?
      return render_error_response("Penggalangan Dana Non Beasiswa berdasarkan Kategori #{params[:kategori]} tidak ada!")
    end
  
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:non_beasiswa_id.in => non_beasiswa.pluck(:id))
    penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
  
    pengajuan_penggalangan_dana = []
  
    if penggalangan_dana.length > 1
      penggalangan_dana.each do |data|
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: data.pengajuan_bantuan_id).first
        pengajuan_penggalangan_dana << data.attributes.merge({
          pengajuan_bantuan_id: pengajuan_bantuan,
          durasi: getDurasiPenggalanganDana(data.id),
          total_donatur: getTotalDonaturByPenggalanganDana(data.id)
        })
      end
      pengajuan_penggalangan_dana = pengajuan_penggalangan_dana.reverse
    else
      new_penggalangan_dana = penggalangan_dana.first
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: new_penggalangan_dana.pengajuan_bantuan_id).first
      pengajuan_penggalangan_dana = new_penggalangan_dana.attributes.merge({
        pengajuan_bantuan_id: pengajuan_bantuan,
        durasi: getDurasiPenggalanganDana(new_penggalangan_dana.id),
        total_donatur: getTotalDonaturByPenggalanganDana(new_penggalangan_dana.id)
      })
    end
  
    render json: {
      response_code: Constants::RESPONSE_SUCCESS, 
      response_message: "Success", 
      data: pengajuan_penggalangan_dana
    }, status: :ok
  end

  #Memilih Kasus Penggalangan Dana
  def selectPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if penggalangan_dana.nil?
      return render_error_response("Penggalangan dana tidak ditemukan!")
    end
  
    pengajuan_bantuan = nil
    non_beasiswa = nil
    data_pengajuan_beasiswa = []
    penanggung_jawab = {}
  
    if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
      penanggung_jawab = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
      penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
        next if index == 0
  
        data_pengajuan_beasiswa << Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: data).first
      end
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
      non_beasiswa = Pengajuan::NonBeasiswa.where(id: pengajuan_bantuan.non_beasiswa_id).first
    end
  
    selected_penggalangan_dana = penggalangan_dana.attributes.merge({
      pengajuan_bantuan_id: pengajuan_bantuan || penanggung_jawab,
      data_donatur: getDataDonaturByPenggalanganDana(penggalangan_dana.id),
      penerima_bantuan: non_beasiswa || data_pengajuan_beasiswa,
      durasi: getDurasiPenggalanganDana(penggalangan_dana.id)
    })
  
    selected_penggalangan_dana["penanggung_jawab"] = selected_penggalangan_dana.delete('pengajuan_bantuan_id')
    render json: {
      response_code: Constants::RESPONSE_SUCCESS, 
      response_message: "Success", 
      data: selected_penggalangan_dana
    }, status: :ok
  end

  def getTotalDonaturByPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
    if not penggalangan_dana.donasi_id.present?
      total_donatur = 0
    else
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      if not donasi.present?
        total_donatur = 0
      else
        donatur = User::Donatur.where(:donasi_id.in => donasi.pluck(:id))
        total_donatur = donatur.group_by(&:itself).transform_values(&:count).length
      end
    end
    return total_donatur
  end

  def getTotalPenggalanganDana
    penggalangan_dana_count = Penggalangan::PenggalanganDana.count
    render json: {
      response_code: Constants::RESPONSE_SUCCESS, 
      response_message: "Success", 
      data: penggalangan_dana_count
    }, status: :ok
  end

  def getDataDonaturByPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
    
    return {} unless penggalangan_dana.present? && penggalangan_dana.donasi_id.present?
    
    donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
    donatur = User::Donatur.donatur_registered.where(:donasi_id.in => donasi.pluck(:id))
    
    if donatur.length > 1
      array_of_data_donatur = donatur.map do |data_donatur|
        data_donasi = Penggalangan::Donasi.approved.where(:id.in => data_donatur.donasi_id)
        {
          id: data_donatur.id,
          nama: data_donatur.nama,
          donasi_id: data_donasi.pluck(:nominal).inject(0, :+)
        }
      end
  
      total_donasi = donasi.length
  
      sorted_data_donatur = array_of_data_donatur.sort_by { |item| -item[:donasi_id] }
      sorted_data_donatur << { total_donasi: total_donasi }
  
      sorted_data_donatur
    else
      donatur_data = donatur.first
      total_donasi = donasi.length
      data_donatur = donatur_data.attributes.merge({
        donasi_id: donasi.pluck(:nominal).inject(0, :+),
        total_donasi: total_donasi
      })
      [data_donatur]
    end
  end

  private
  #form pengaju
  def pengajuan_bantuan_params
    params.permit(
      :nama, 
      :no_telepon,
      :judul_galang_dana,
      :waktu_galang_dana,
      :deskripsi,
      :dana_yang_dibutuhkan,
    )
  end

  def bank_params
    params.permit(:nama_bank, :nomor_rekening, :nama_pemilik_rekening)
  end

  #form non_beasiswa
  def non_beasiswa_params
    params.permit(
      :nama_penerima, 
      :no_telepon_penerima, 
      :kategori,
    )
  end

  def find_pengajuan_bantuan_by_penggalangan_dana(penggalangan_dana)
    pengajuan_bantuan_id = Array(penggalangan_dana.pengajuan_bantuan_id).first
    Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: pengajuan_bantuan_id).first
  end
end

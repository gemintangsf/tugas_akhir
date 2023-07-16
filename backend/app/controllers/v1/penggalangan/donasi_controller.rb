class V1::Penggalangan::DonasiController < ApplicationController
    # before_action :
  def createDonasi
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      is_penggalangan_dana = 0
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: penggalangan_dana.pengajuan_bantuan_id[0]).first
        if not pengajuan_bantuan.present?
          is_penggalangan_dana = 1
        end
      else
        pengajuan_bantuan_by_penggalangan_dana = Pengajuan::PengajuanBantuan.where(id: penggalangan_dana.pengajuan_bantuan_id).first
        if not pengajuan_bantuan_by_penggalangan_dana.present?
          is_penggalangan_dana = 1
        else
          if pengajuan_bantuan_by_penggalangan_dana.jenis == "Beasiswa"
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: penggalangan_dana.pengajuan_bantuan_id).first
          else
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
          end
          if not pengajuan_bantuan.present?
            is_penggalangan_dana = 1
          end
        end
      end
      if is_penggalangan_dana == 1
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Penggalangan Dana tidak ada"
          }, status: :unprocessable_entity
      end
      data_danatur = User::Donatur.where(nomor_telepon: params[:nomor_telepon]).first
      is_struk_pembayaran = 0
      if data_danatur.present?
        donatur = data_danatur
        donasi_donatur = Penggalangan::Donasi.new_donation.where(:id.in => data_danatur.donasi_id)
        if donasi_donatur.present?
          if donasi_donatur.pluck(:struk_pembayaran) == [nil]
            is_struk_pembayaran = 1
          end
        end
      else
        donatur = User::Donatur.new(
          nama: params[:nama],
          nomor_telepon: params[:nomor_telepon],
          status: Enums::StatusDonatur::CANDIDATE
        )
      end
      if is_struk_pembayaran == 1
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak dapat melakukan donasi, Upload struk pembayaran pada donasi sebelumnya!"
          }, status: :unprocessable_entity
      else
        random_number = 6.times.map{ 10 + Random.rand(11) }
        nomor_referensi = random_number.join("")
        waktu_berakhir = Time.now + 24.hours.to_i
        donasi = Penggalangan::Donasi.new(donasi_params)
        donasi.assign_attributes({
          waktu_berakhir: waktu_berakhir,
          nomor_referensi: nomor_referensi, 
          status: Enums::StatusDonasi::NEW,
        })
        array_of_donasi_id = []
        if not penggalangan_dana.donasi_id.present?
          array_of_donasi_id << donasi.id
          penggalangan_dana.assign_attributes(donasi_id: array_of_donasi_id)
        else
          penggalangan_dana.donasi_id << donasi.id
        end
        new_array_donasi_donatur = []
        if not donatur.donasi_id.present?
          new_array_donasi_donatur << donasi.id
          donatur.assign_attributes(donasi_id: new_array_donasi_donatur)
        else
          donatur.donasi_id << donasi.id
        end
        if donatur.save(:validate => false) and donasi.save and penggalangan_dana.save
          render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success", 
            data: {donasi: donasi, donatur: donatur, penggalangan_dana: penggalangan_dana},
            }, status: :created
        else
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: {donasi: donasi.errors.full_messages, penggalangan_dana: penggalangan_dana.errors.full_messages}
            }, status: :unprocessable_entity
        end
      end
    end
  end

  def getDurasiDonasi
    donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
    if not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Donasi baru tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      seconds_diff = (donasi.waktu_berakhir - Time.now).to_i.abs
  
      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600
  
      minutes = seconds_diff / 60
      seconds_diff -= minutes * 60
  
      seconds = seconds_diff
      if seconds_diff < 1
        donasi.assign_attributes(status: Enums::StatusDonasi::EXPIRED)
        donasi.save!(:validate => false)
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}",
        }, status: :ok
    end
  end

  def uploadStrukPembayaran
    donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
    if not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Donasi baru tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      if params[:struk_pembayaran].blank?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Path struk pembayaran tidak boleh kosong!"
          }, status: :unprocessable_entity
      else
        donasi.assign_attributes(struk_pembayaran: params[:struk_pembayaran])
        if donasi.save!(:validate => false)
          render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success", 
            data: donasi,
            }, status: :created
        end
      end
    end
  end

  def approvalDonasi
    donasi = Penggalangan::Donasi.new_donation.where(id: params[:id]).first
    if not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Donasi baru tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      if params[:is_approve] == "true"
        status_donasi = Enums::StatusDonasi::APPROVED
        penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id => donasi.id).first
        total_nominal_awal = penggalangan_dana.total_nominal_terkumpul
        nominal_donasi = donasi.nominal
        total_nominal_terkumpul = penggalangan_dana.total_nominal_terkumpul + donasi.nominal
        penggalangan_dana.assign_attributes({
          total_nominal_terkumpul: total_nominal_terkumpul})
      else
        status_donasi = Enums::StatusDonasi::REJECTED
      end
      donasi.assign_attributes(status: status_donasi)
      #check donatur
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
      if donasi.save and penggalangan_dana.save
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: {penggalangan_dana: penggalangan_dana, donatur: donatur, donasi: donasi, password_donatur: password_candidate},
          }, status: :ok
      else
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: {donasi: donasi.errors.full_messages, penggalangan_dana: penggalangan_dana.errors.full_messages}
          }, status: :unprocessable_entity
      end
    end
  end

  def getAllNewDonasi
    donasi = Penggalangan::Donasi.new_donation
    if not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada data donasi!"
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id.in => donasi.pluck(:id))
      donatur = User::Donatur.where(:donasi_id.in => donasi.pluck(:id))
      if donasi.length > 1
        array_of_data_donasi = []
        donasi.each_with_index do |data_donation, index_donasi|
          penggalangan_dana = Penggalangan::PenggalanganDana.where(:donasi_id => data_donation.id).first
          donatur = User::Donatur.where(:donasi_id => data_donation.id).first
          if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id[0])
          else
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana.pengajuan_bantuan_id)
          end
          array_of_data_donasi << penggalangan_dana.attributes.merge({
            :pengajuan_bantuan_id => pengajuan_bantuan,
            :donasi_id => donatur.attributes.merge(:donasi_id => data_donation)
          })
        end
        data_donasi = array_of_data_donasi.reverse
      else
        data_penggalangan_dana = penggalangan_dana.first
        if data_penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id.in => penggalangan_dana.pluck(:pengajuan_bantuan_id)[0])
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id.in => penggalangan_dana.pluck(:pengajuan_bantuan_id))
        end
        data_donasi = data_penggalangan_dana.attributes.merge({
          :pengajuan_bantuan_id => pengajuan_bantuan,
          :donasi_id => donatur.first.attributes.merge(:donasi_id => donasi)
        })
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: data_donasi
        }, status: :ok
    end
  end

  def getApprovedDonasiByPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      if not donasi.present?
        render json: {
          response_code: 422,
          response_message: "Tidak ada data donasi pada penggalangan dana ini!"
          }, status: :unprocessable_entity
      else
        donatur = User::Donatur.donatur_registered.where(:donasi_id.in => donasi.pluck(:id))
        if donatur.length > 1
          array_of_donatur_donasi = []
          donasi.each_with_index do |data_donasi, index_donasi|
            donatur.each_with_index do |data_donatur, index_donatur|
              if index_donasi == index_donatur
                array_of_donatur_donasi << data_donatur.attributes.merge(:donasi_id => data_donasi)
              end
            end
          end
        else
          donasi_donatur = donatur.first.attributes.merge(:donasi_id => donasi)
        end
        render json: {
          response_code: 200, 
          response_message: "Success", 
          data: donasi_donatur
          }, status: :ok
      end
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

  def getAllDonasiTotal
    donasi = Penggalangan::Donasi.approved
    if not donasi.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS,
        response_message: "Success",
        data: 0
        }, status: :ok
    else
      donasi_terkumpul = donasi.pluck(:nominal).inject(0, :+)
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: donasi_terkumpul
        }, status: :ok
    end
  end

  private
  # Form Donasi
  def donasi_params
    params.permit(
      :nominal, 
      :nama_pemilik_rekening, 
    )
  end
end

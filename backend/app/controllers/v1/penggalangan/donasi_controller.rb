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
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        id_pengajuan = penggalangan_dana.pengajuan_bantuan_id[0]
      else
        id_pengajuan = penggalangan_dana.pengajuan_bantuan_id
      end
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: id_pengajuan).first
      if not pengajuan_bantuan.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Penggalangan Dana tidak ada"
          }, status: :unprocessable_entity
      else
        donatur = []
        donatur_registered = User::Donatur.where(nomor_telepon: params[:nomor_telepon]).first
        if donatur_registered.present?
          donatur = donatur_registered
        else
          donatur = User::Donatur.new(
            nama: params[:nama],
            nomor_telepon: params[:nomor_telepon],
            status: Enums::StatusDonatur::CANDIDATE,
          )
        end
        random_number = 6.times.map{ 10 + Random.rand(11) }
        nomor_referensi = random_number.join("")
        waktu_berakhir = Time.now + 24.hours.to_i
        donasi = Penggalangan::Donasi.new(donasi_params)
        donasi.assign_attributes({
          penggalangan_dana: penggalangan_dana,
          donatur: donatur,
          waktu_berakhir: waktu_berakhir,
          nomor_referensi: nomor_referensi, 
          status: Enums::StatusDonasi::NEW,
        })
        if donatur.save!(:validate => false) and donasi.save
          render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success", 
            data: {donasi: donasi, donatur: donatur, penggalangan_dana: penggalangan_dana},
            }, status: :created
        else
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: donasi.errors.full_messages
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
      file_upload = params[:file]
      size_file = file_upload.size
      file_upload_split = file_upload.original_filename.split('.')
      extension = file_upload_split[file_upload_split.length - 1].downcase
      if extension != "pdf" and extension != "jpg" and extension != "jpeg" and extension != "png" 
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Format file hanya bisa PDF/JPG/JPEG/PNG"
          }, status: :unprocessable_entity
      #menghitung limit dari file jika lebih dari 1 MB dan file sesuai dengan format
      elsif size_file > 1000000  
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "File lebih besar dari limit"
          }, status: :unprocessable_entity
      end
      new_filename = SecureRandom.uuid + "." + extension
      file_path = Rails.application.config.dir_upload + Rails.application.config.path_upload_separator +
          "upload_struk_pembayaran" + Rails.application.config.path_upload_separator + new_filename
      File.open(file_path, 'wb') do |file|
        file.write(file_upload.read)
      end
      donasi.assign_attributes(struk_pembayaran: new_filename)
      if donasi.save!(:validate => false)
        render json: {
          response_code: Constants::RESPONSE_CREATED, 
          response_message: "Success", 
          data: "Berhasil melakukan upload struk pembayaran!",
          }, status: :created
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
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:_id => donasi.penggalangan_dana_id).first
      if params[:is_approve] == "true"
        status_donasi = Enums::StatusDonasi::APPROVED
        total_nominal_awal = penggalangan_dana.total_nominal_terkumpul
        nominal_donasi = donasi.nominal
        total_nominal_terkumpul = penggalangan_dana.total_nominal_terkumpul + donasi.nominal
        penggalangan_dana.assign_attributes({total_nominal_terkumpul: total_nominal_terkumpul})
      else
        status_donasi = Enums::StatusDonasi::REJECTED
      end
      donasi.assign_attributes(status: status_donasi)
      #check donatur
      donatur = User::Donatur.where(id: donasi.donatur_id).first
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
    donasi = Penggalangan::Donasi.new_donation.reverse
    if not donasi.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada data donasi!"
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:_id.in => donasi.pluck(:penggalangan_dana_id)).reverse
      donatur = User::Donatur.where(:_id.in => donasi.pluck(:donatur_id)).reverse
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: {donasi: donasi, donatur: donatur, penggalangan_dana: penggalangan_dana},
        }, status: :ok
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
        }, status: :unprocessable_entity
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

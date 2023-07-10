class V1::Penggalangan::PenggalanganDanaController < ApplicationController
  # before_action :
  #Untuk membuat penggalangan dana beasiswa
  def createPenggalanganDanaBeasiswa
    penggalangan_dana_beasiswa = Pengajuan::PengajuanBantuan.pengajuan_baru_admin
    if penggalangan_dana_beasiswa.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan Beasiswa sedang berlangsung!"
        }, status: :unprocessable_entity
    else
      data_admin = User::Admin.where(id: params[:id]).first
      nama = data_admin.nama
      nomor_telepon = data_admin.nomor_telepon
      no_identitas_pengaju = "-"
      nomor_rekening = data_admin.nomor_rekening
      nama_pemilik_rekening = "Rekening Admin"
      bank = "Bank Admin"
      dana_yang_dibutuhkan = 0
      status_pengajuan = Enums::StatusPengajuan::ADMIN
      status_penyaluran = Enums::StatusPenyaluran::NULL
      waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
      if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tanggal harus lebih dari hari sekarang!"
          }, status: :unprocessable_entity
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(
          jenis: "Beasiswa"
          nama: nama, 
          no_identitas_pengaju: no_identitas_pengaju, 
          no_telepon: nomor_telepon, 
          nomor_rekening: nama_pemilik_rekening, 
          nama_pemilik_rekening: nomor_rekening, 
          bank: bank, 
          waktu_galang_dana: waktu_galang_dana, 
          judul_galang_dana: params[:judul_galang_dana], 
          deskripsi: params[:deskripsi], 
          dana_yang_dibutuhkan: dana_yang_dibutuhkan, 
          status_pengajuan: status_pengajuan,
          status_penyaluran: status_penyaluran,
        )
        total_nominal_terkumpul = 0
        penggalangan_dana = Penggalangan::PenggalanganDana.new(
          total_pengajuan: params[:total_pengajuan],
          total_nominal_terkumpul: total_nominal_terkumpul,
        )
        penggalangan_dana.pengajuan_bantuan = pengajuan_bantuan
        if penggalangan_dana.save and pengajuan_bantuan.save
          render json: {
          response_code: Constants::RESPONSE_CREATED, 
          response_message: "Success", 
          data: {penggalangan_dana: penggalangan_dana, pengajuan_bantuan: pengajuan_bantuan}
          }, status: :created
        else
          render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: {penggalangan_dana: penggalangan_dana.errors.full_messages, pengajuan_bantuan: pengajuan_bantuan.errors.full_messages}
          }, status: :unprocessable_entity
        end   
      end
    end
  end

  def createPenggalanganDanaNonBeasiswa
    total_pengajuan = 1
    total_nominal_terkumpul = 0
    penggalangan_dana = Penggalangan::PenggalanganDana.new(
      total_pengajuan: total_pengajuan,
      total_nominal_terkumpul: total_nominal_terkumpul,
    )
    no_identitas_pengaju = "-"
    no_identitas_penerima = "-"
    bukti_butuh_bantuan = "-"
    status_pengajuan = Enums::StatusPengajuan::APPROVED
    status_penyaluran = Enums::StatusPenyaluran::NEW
    waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
    if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tanggal harus lebih dari hari sekarang!"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
      pengajuan_bantuan.assign_attributes({
        jenis: "NonBeasiswa",
        no_identitas_pengaju: no_identitas_pengaju,
        waktu_galang_dana: waktu_galang_dana,
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran,
        penggalangan_dana: [penggalangan_dana]
      })
      non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
      non_beasiswa.assign_attributes({
        no_identitas_penerima: no_identitas_penerima,
        bukti_butuh_bantuan: bukti_butuh_bantuan,
        pengajuan_bantuan: pengajuan_bantuan})
      if penggalangan_dana.save and pengajuan_bantuan.save and non_beasiswa.save
          render json: {
              response_code: Constants::RESPONSE_CREATED, 
              response_message: "Success", 
              data: {penggalangan_dana: penggalangan_dana, pengajuan_bantuan: pengajuan_bantuan, non_beasiswa: non_beasiswa},
              }, status: :created
      else
          render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: {penggalangan_dana: penggalangan_dana.errors.full_messages, pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, non_beasiswa: non_beasiswa.errors.full_messages}
              }, status: :unprocessable_entity
      end
    end
  end

  def getAllPenggalanganDana
    pengajuan_bantuan_penggalangan_dana = Pengajuan::PengajuanBantuan.penggalangan_dana
    if not pengajuan_bantuan_penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada Penggalangan Dana yang berlangsung"
        }, status: :unprocessable_entity
    else
      array_of_pengajuan_bantuan_id = []
      if pengajuan_bantuan_penggalangan_dana.length > 1
        penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan_penggalangan_dana.pluck(:id)).reverse
        penggalangan_dana.each_with_index do |data, index|
          if data.pengajuan_bantuan_id.kind_of?(Array)
            array_of_pengajuan_bantuan_id << data.pengajuan_bantuan_id[0]
          else
            array_of_pengajuan_bantuan_id << data.pengajuan_bantuan_id
          end
        end
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(:_id.in => array_of_pengajuan_bantuan_id).reverse
      else
        penggalangan_dana = Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: pengajuan_bantuan_penggalangan_dana.first.id).first
        if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: penggalangan_dana.pengajuan_bantuan_id[0]).first
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: penggalangan_dana.pengajuan_bantuan_id).first
        end
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: {penggalangan_dana: penggalangan_dana, pengajuan_bantuan: pengajuan_bantuan}
      }, status: :ok
    end
  end

  def getDurasiPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan Dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: penggalangan_dana.pengajuan_bantuan_id[0]).first
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
      end
      end_date = pengajuan_bantuan.waktu_galang_dana.to_datetime
      durasi = (end_date - DateTime.now).to_i + 1
      if durasi < 1
        if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
          penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
            if index > 0
              pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
            else
              pengajuan_bantuan_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.where(id: penggalangan_dana.pengajuan_bantuan_id).first
              pengajuan_bantuan_admin.assign_attributes(
                status_pengajuan: Enums::StatusPengajuan::DONE,
              )
              pengajuan_bantuan_admin.save!
            end
            pengajuan_bantuan.assign_attributes(
              status_pengajuan: Enums::StatusPengajuan::DONE,
              status_penyaluran: Enums::StatusPenyaluran::PENDING
            )
            pengajuan_bantuan.save!
          end
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
          pengajuan_bantuan.assign_attributes(
            status_pengajuan: Enums::StatusPengajuan::DONE,
            status_penyaluran: Enums::StatusPenyaluran::PENDING
          )
          pengajuan_bantuan.save!
        end
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: durasi.to_s + " Hari Lagi"
      }, status: :ok
    end
  end

  def getNominalTerkumpulPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(_id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan Dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: total_donasi
        }, status: :ok
    end
  end

  def getPenggalanganDanaNonBeasiswaByKategori
    if params[:kategori] != "Medis" and params[:kategori] != "Bencana"
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis atau Bencana"
        }, status: :unprocessable_entity
    else
      pengajuan_penggalangan_dana = Pengajuan::PengajuanBantuan.penggalangan_dana.where(jenis: "NonBeasiswa").reverse
      if not pengajuan_penggalangan_dana.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada Penggalangan Dana Non Beasiswa yang berlangsung"
          }, status: :unprocessable_entity
      else
        penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_penggalangan_dana.pluck(:id)).reverse
        non_beasiswa = Pengajuan::NonBeasiswa.where(:pengajuan_bantuan_id.in => pengajuan_penggalangan_dana.pluck(:id)).where(kategori: params[:kategori])
        if not non_beasiswa.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Penggalangan Dana Non Beasiswa berdasarkan Kategori #{params[:kategori]} tidak ada!"
            }, status: :unprocessable_entity
        else
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: {penggalangan_dana: penggalangan_dana, pengajuan: pengajuan_penggalangan_dana}
          }, status: :ok
        end
      end
    end
  end

  #Memilih Kasus Penggalangan Dana
  def selectPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      array_of_pengajuan_bantuan_id = []
      non_beasiswa = []
      pengajuan_bantuan = []
      if not penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
        if pengajuan_bantuan.jenis == "NonBeasiswa"
          non_beasiswa = Pengajuan::NonBeasiswa.where(pengajuan_bantuan_id: pengajuan_bantuan.id).first
        end
      else
        penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
          if index > 0
            array_of_pengajuan_bantuan_id << data
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(:_id.in => array_of_pengajuan_bantuan_id)
          end
        end
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: {penggalangan_dana: penggalangan_dana, pengajuan_bantuan: pengajuan_bantuan, detail: non_beasiswa}
      }, status: :ok
    end
  end

  def getTotalDonaturInPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id)
      if not donasi.present?
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: "0 Donatur"
        }, status: :ok
      else
        donatur = donasi.pluck(:donatur_id)
        total_donatur = donatur.group_by(&:itself).transform_values(&:count).length
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: total_donatur.to_s + " Donatur"
        }, status: :ok
      end
    end
  end

  def getTotalPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.all
    if penggalangan_dana.length == 0
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: 0
      }, status: :ok
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana
      if pengajuan_bantuan.length == 0
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: 0
        }, status: :ok
      else
        total_beasiswa = 0
        total_non_beasiswa = 0
        pengajuan_bantuan.each do |data|
          if data.jenis == "Beasiswa"
            total_beasiswa = 1
          else
            total_non_beasiswa = pengajuan_bantuan.where(jenis: "NonBeasiswa").length
          end
        end
        total_penggalangan_dana = total_beasiswa + total_non_beasiswa
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: total_penggalangan_dana
        }, status: :ok
      end
    end
  end

  def getTotalDonatur
    donatur = User::Donatur.where(status: true)
    if not donatur.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: "0 Donatur"
      }, status: :ok
    else
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: donatur.length.to_s + " Donatur"
      }, status: :ok
    end
  end

  def getTotalPenerimaBantuan
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.done
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: 0
      }, status: :ok
    else
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: pengajuan_bantuan.length
      }, status: :ok
    end
  end

  private
  #form pengaju
  def pengajuan_bantuan_params
    params.permit(
      :nama, 
      :no_telepon, 
      :nomor_rekening, 
      :nama_pemilik_rekening, 
      :bank,
      :judul_galang_dana,
      :waktu_galang_dana,
      :deskripsi,
      :dana_yang_dibutuhkan,
    )
  end
  #form non_beasiswa
  def non_beasiswa_params
    params.permit(
      :nama_penerima, 
      :no_telepon_penerima, 
      :kategori,
    )
  end
end

class V1::Penggalangan::PenggalanganDanaController < ApplicationController
  # before_action :
  #Untuk membuat penggalangan dana beasiswa
  def createPenggalanganDanaBeasiswa
    penggalangan_dana_beasiswa = Pengajuan::PengajuanBantuan.pengajuan_baru_admin
    if penggalangan_dana_beasiswa.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penggalangan Dana Beasiswa sedang berlangsung!"
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
          jenis: "Beasiswa",
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
        array_of_pengajuan_bantuan_id = []
        array_of_pengajuan_bantuan_id << pengajuan_bantuan.id
        penggalangan_dana.assign_attributes({pengajuan_bantuan_id: array_of_pengajuan_bantuan_id})
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
      non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
      non_beasiswa.assign_attributes({
        no_identitas_penerima: no_identitas_penerima,
        bukti_butuh_bantuan: bukti_butuh_bantuan})
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
      pengajuan_bantuan.assign_attributes({
        jenis: "NonBeasiswa",
        no_identitas_pengaju: no_identitas_pengaju,
        waktu_galang_dana: waktu_galang_dana,
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran,
        non_beasiswa: non_beasiswa,
        penggalangan_dana: [penggalangan_dana]
      })
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
    penggalangan_dana_new = Penggalangan::PenggalanganDana.all
    if not penggalangan_dana_new.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada Penggalangan Dana yang berlangsung"
        }, status: :unprocessable_entity
    else
      if penggalangan_dana_new.length > 1
        id_pengajuan_bantuan = []
        penggalangan_dana_new.each do |data|
          if data.pengajuan_bantuan_id.kind_of?(Array)
            id_pengajuan_bantuan << data.pengajuan_bantuan_id[0]
          else
            id_pengajuan_bantuan << data.pengajuan_bantuan_id
          end
        end
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id.in => id_pengajuan_bantuan)
        if not pengajuan_bantuan.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada Penggalangan Dana yang berlangsung"
            }, status: :unprocessable_entity
        else
          list_data_penggalangan_dana = []
          penggalangan_dana_beasiswa = []
          penggalangan_dana_non_beasiswa = []
          penggalangan_dana_by_pengajuan = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
          penggalangan_dana_by_pengajuan.each_with_index do |data_penggalangan_dana, index_penggalangan_dana|
            pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
              if index_pengajuan_bantuan == index_penggalangan_dana
                if data_penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
                  penggalangan_dana_beasiswa << data_penggalangan_dana.attributes.merge(
                    {
                      :pengajuan_bantuan_id => data_pengajuan,
                      :durasi => getDurasiPenggalanganDana(data_penggalangan_dana.id),
                      :nominal_terkumpul => getNominalTerkumpulPenggalanganDana(data_penggalangan_dana.id),
                      :total_donatur => getTotalDonaturByPenggalanganDana(data_penggalangan_dana.id)
                    }
                  )
                else
                  penggalangan_dana_non_beasiswa << data_penggalangan_dana.attributes.merge({
                    :pengajuan_bantuan_id => data_pengajuan,
                    :durasi => getDurasiPenggalanganDana(data_penggalangan_dana.id),
                    :nominal_terkumpul => getNominalTerkumpulPenggalanganDana(data_penggalangan_dana.id),
                    :total_donatur => getTotalDonaturByPenggalanganDana(data_penggalangan_dana.id)
                    }) 
                end
              end
            end
          end
          list_data_penggalangan_dana << penggalangan_dana_beasiswa
          list_data_penggalangan_dana << penggalangan_dana_non_beasiswa.reverse
          if penggalangan_dana_beasiswa == []
            new_data_pengajuan = penggalangan_dana_non_beasiswa.reverse
          else
            new_data_pengajuan = list_data_penggalangan_dana.flatten
          end
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: new_data_pengajuan
          }, status: :ok
        end
      else
        if penggalangan_dana_new.first.pengajuan_bantuan_id.kind_of?(Array)
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana_new.first.pengajuan_bantuan_id[0]).first
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => penggalangan_dana_new.first.pengajuan_bantuan_id).first
        end
        new_data_penggalangan = penggalangan_dana_new.first.attributes.merge(pengajuan_bantuan_id: pengajuan_bantuan)
        if not pengajuan_bantuan.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada Penggalangan Dana yang berlangsung"
            }, status: :unprocessable_entity
        else
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: new_data_penggalangan
          }, status: :ok
        end
      end
    end
  end

  def getDurasiPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
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
      return durasi
    end
  end

  def getNominalTerkumpulPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(_id: penggalangan_dana_id).first
    if not penggalangan_dana.donasi_id.present?
      total_donasi = 0
    else
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      if not donasi.present?
        total_donasi = 0
      else
        total_donasi = donasi.pluck(:nominal).inject(0, :+)
      end
      return total_donasi
    end
  end

  def getPenggalanganDanaNonBeasiswaByKategori
    if params[:kategori] != "Medis" and params[:kategori] != "Bencana" and params[:kategori] != "Duka"
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis/Bencana/Duka"
        }, status: :unprocessable_entity
    else
      pengajuan_penggalangan_dana = Pengajuan::PengajuanBantuan.penggalangan_dana.where(jenis: "NonBeasiswa").reverse
      if not pengajuan_penggalangan_dana.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada Penggalangan Dana Non Beasiswa yang berlangsung"
          }, status: :unprocessable_entity
      else
        non_beasiswa = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_penggalangan_dana.pluck(:non_beasiswa_id)).where(kategori: params[:kategori])
        if not non_beasiswa.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Penggalangan Dana Non Beasiswa berdasarkan Kategori #{params[:kategori]} tidak ada!"
            }, status: :unprocessable_entity
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:non_beasiswa_id.in => non_beasiswa.pluck(:id))
          penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
          pengajuan_penggalangan = []
          if penggalangan_dana.length > 1
            penggalangan_dana.each do |data|
              pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: data.pengajuan_bantuan_id)
              pengajuan_penggalangan << data.attributes.merge({
                :pengajuan_bantuan_id => pengajuan_bantuan,
                :durasi => getDurasiPenggalanganDana(data.id),
                :nominal_terkumpul => getNominalTerkumpulPenggalanganDana(data.id),
                :total_donatur => getTotalDonaturInPenggalanganDana(data.id)
                })
            end
            pengajuan_penggalangan_dana = pengajuan_penggalangan.reverse
          else
            new_penggalangan_dana = penggalangan_dana.first
            pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: new_penggalangan_dana.pengajuan_bantuan_id)
            pengajuan_penggalangan_dana = new_penggalangan_dana.attributes.merge({
              :pengajuan_bantuan_id => pengajuan_bantuan,
              :durasi => getDurasiPenggalanganDana(new_penggalangan_dana.id),
              :nominal_terkumpul => getNominalTerkumpulPenggalanganDana(new_penggalangan_dana.id),
              :total_donatur => getTotalDonaturInPenggalanganDana(new_penggalangan_dana.id)
            })
          end
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: pengajuan_penggalangan_dana
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
      if not penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
        if pengajuan_bantuan.jenis == "NonBeasiswa"
          non_beasiswa = Pengajuan::NonBeasiswa.where(id: pengajuan_bantuan.non_beasiswa_id).first
          selected_penggalangan_dana = penggalangan_dana.attributes.merge({
            :pengajuan_bantuan_id => pengajuan_bantuan.attributes.merge({:non_beasiswa_id => non_beasiswa,}),
            :data_donatur => getDataDonaturByPenggalanganDana(penggalangan_dana.id),
            })
        else
          selected_penggalangan_dana = penggalangan_dana.attributes.merge(:pengajuan_bantuan_id => pengajuan_bantuan)
        end
      else
        array_of_pengajuan_bantuan_id = []
        data_pengajuan_beasiswa = []
        penggalangan_dana.pengajuan_bantuan_id.each do |data_penggalangan_dana|
          array_of_pengajuan_bantuan_id << data_penggalangan_dana
        end
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id.in => array_of_pengajuan_bantuan_id)
        pengajuan_bantuan.each_with_index do |data, index|
          penggalangan_dana.pengajuan_bantuan_id[index] = data
        end
        selected_penggalangan_dana = penggalangan_dana.attributes.merge({
          :data_donatur => getDataDonaturByPenggalanganDana(penggalangan_dana.id),
        })
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: selected_penggalangan_dana
      }, status: :ok
    end
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

  def getTotalDonasiByPenggalanganDana(penggalangan_dana_id)
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

  def getDataDonaturByPenggalanganDana(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
    if not penggalangan_dana.present?
      data_donatur = {}
    elsif not penggalangan_dana.donasi_id.present?
      data_donatur = {}
    else
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      donatur = User::Donatur.donatur_registered.where(:donasi_id.in => donasi.pluck(:id))
      if donatur.length > 1
        array_of_data_donatur = []
        array_of_data_donasi = []
        donatur.each_with_index do |data_donatur, index_donatur|
          data_donasi = donasi.where(:id.in => data_donatur.donasi_id)
          array_of_data_donatur << data_donatur.attributes.merge(:donasi_id => data_donasi.pluck(:nominal).inject(0, :+))
          array_of_data_donasi << data_donasi
        end
        data_donatur = array_of_data_donatur.sort_by { |item| -item[:donasi_id] }
        data_donatur << {total_donasi: array_of_data_donasi.flatten.length}
      else
        donatur_data = donatur.first
        data_donatur = donatur_data.attributes.merge({
          :donasi_id => donasi.pluck(:nominal).inject(0, :+),
          :total_donasi => donasi.length
          })
      end
      return data_donatur
    end
  end

  def getTotalPengeluaran
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    elsif not penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Batch beasiswa tidak ada!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(id: penggalangan_dana.donasi_id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: penyaluran
        }, status: :ok
    end
  end

  def getSaldoAwal
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_done_admin
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS,
        response_message: "Success",
        data: 0
        }, status: :ok
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
      donasi = Penggalangan::Donasi.approved.where(:id => penggalangan_dana.donasi_id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      saldo_akhir = total_donasi - penyaluran
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: saldo_akhir
        }, status: :ok
    end
  end

  def getSaldoAkhir
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    elsif not penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Batch Beasiswa tidak ada!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(:id => penggalangan_dana.donasi_id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      saldo_akhir = total_donasi - penyaluran
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: saldo_akhir
        }, status: :ok
    end
  end

  def getApprovedDonasiByPenggalanganDana
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Penggalangan Dana tidak ditemukan!"
        }, status: :unprocessable_entity
    elsif not penggalangan_dana.donasi_id.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Belum ada donasi pada penggalangan dana ini!"
        }, status: :unprocessable_entity
    else
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(:id => penggalangan_dana.pengajuan_bantuan_id[0]).first
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(:id => penggalangan_dana.pengajuan_bantuan_id).first
      end
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      if not donasi.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada data donasi pada penggalangan dana ini!"
          }, status: :unprocessable_entity
      else
        if donasi.length > 1
          data_donasi = []
          donasi.each_with_index do |data_donation, index_donasi|
            donatur = User::Donatur.donatur_registered.where(:donasi_id => data_donation.id)
            data_donasi << penggalangan_dana.attributes.merge({
              :pengajuan_bantuan_id => pengajuan_bantuan,
              :donasi_id => donatur.first.attributes.merge(:donasi_id => data_donation)
            })
          end
          donasi_penggalangan_dana = data_donasi.reverse
        else
          donatur = User::Donatur.donatur_registered.where(:donasi_id => donasi.first.id)
          donasi_penggalangan_dana = penggalangan_dana.attributes.merge({
            :pengajuan_bantuan_id => pengajuan_bantuan,
            :donasi_id => donatur.first.attributes.merge(:donasi_id => donasi)
          })
        end
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: donasi_penggalangan_dana
          }, status: :ok
      end
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

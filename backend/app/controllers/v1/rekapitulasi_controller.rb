class V1::RekapitulasiController < ApplicationController
    # before_action :
  def getRekapitulasiBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru_admin
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Batch Beasiswa Tidak ada" 
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id)).first
      array_of_penerima_beasiswa = []
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        if penggalangan_dana.pengajuan_bantuan_id.length > 1
          penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
            if index > 0
              penerima_beasiswa = Pengajuan::PengajuanBantuan.penggalangan_dana.where(:id => data).first
              beasiswa= Pengajuan::Beasiswa.where(:id => penerima_beasiswa.beasiswa_id).first
              array_of_penerima_beasiswa << penerima_beasiswa.attributes.merge({
                nominal_penyaluran: beasiswa.nominal_penyaluran
              })
            end
          end
          penerima_beasiswa = array_of_penerima_beasiswa
        else
          penerima_beasiswa = {}
        end
        rekapitulasi_beasiswa = penggalangan_dana.attributes.merge({
          pengajuan_bantuan_id: penerima_beasiswa,
          total_donasi: getTotalDonasi(penggalangan_dana.id),
          total_pengeluaran: getTotalPengeluaran(penggalangan_dana.id),
          saldo_awal: getSaldoAwal(),
          saldo_akhir:  getTotalDonasi(penggalangan_dana.id) - getTotalPengeluaran(penggalangan_dana.id),
          daftar_bulan: getMonthRekapitulasiBeasiswa(penggalangan_dana.id)
          })
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: rekapitulasi_beasiswa
        }, status: :ok
      else
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Data Batch Beasiswa Tidak ada" 
          }, status: :unprocessable_entity
      end
    end
  end
  
  def getAllRekapitulasiBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.batch_beasiswa
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Batch Beasiswa tidak ada!" 
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
    end
  end

  def getBacthBeasiswa

  end

  def getRekapitulasiNonBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.rekapitulasi_non_beasiswa
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Rekapitulasi Dana Non Beasiswa tidak ada!" 
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_bantuan.pluck(:non_beasiswa_id))
      if pengajuan_bantuan.length > 1
        array_of_pengajuan = []
        pengajuan_bantuan.each do |data|
          non_beasiswa = Pengajuan::NonBeasiswa.where(id: data.non_beasiswa_id)
          array_of_pengajuan << data.attributes.merge({
            :non_beasiswa_id => non_beasiswa.first,
            :penggalangan_dana => Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: data.id).first,
            })
        end
        rekapitulasi_non_beasiswa = array_of_pengajuan.reverse
      else
        data_pengajuan = pengajuan_bantuan.first
        rekapitulasi_non_beasiswa = data_pengajuan.attributes.merge({
          :non_beasiswa_id => non_beasiswa.first,
          :penggalangan_dana => Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: data_pengajuan.id).first
        })
      end
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: rekapitulasi_non_beasiswa
        }, status: :ok
    end
  end

  def selectPenyaluranBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.penyaluran_beasiswa.where(id: params[:id]).first
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penerima Bantuan Dana Beasiswa tidak ada atau sudah dilakukan penyaluran" 
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: pengajuan_bantuan.id).first
      if not penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Penerima Bantuan Dana Beasiswa tidak ada!" 
          }, status: :unprocessable_entity
      else
        if params[:is_penyaluran].blank?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "is_penyaluran tidak boleh kosong!"
            }, status: :unprocessable_entity
        else 
          if params[:is_penyaluran] != "true" and params[:is_penyaluran] != "false"
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "is_penyaluran hanya dapat true atau false!"
              }, status: :unprocessable_entity
          else
            if params[:is_penyaluran] == "true"
              status_penyaluran = Enums::StatusPenyaluran::DELIVERED
              penggalangan_dana.total_nominal_terkumpul = penggalangan_dana.total_nominal_terkumpul - params[:nominal_penyaluran]
              beasiswa = Pengajuan::Beasiswa.where(:id => pengajuan_bantuan.beasiswa_id).first
              beasiswa.assign_attributes(:nominal_penyaluran => params[:nominal_penyaluran])
            else
              status_penyaluran = Enums::StatusPenyaluran::PENDING
            end
            pengajuan_bantuan.assign_attributes(status_penyaluran: status_penyaluran)
            if pengajuan_bantuan.save and beasiswa.save and penggalangan_dana.save
              render json: {
                response_code: Constants::RESPONSE_SUCCESS,
                response_message: "Success",
                data: {pengajuan_bantuan: pengajuan_bantuan, nominal_penyaluran: beasiswa.nominal_penyaluran, nominal_tersisa: penggalangan_dana.total_nominal_terkumpul}
                }, status: :ok
            else
              render json: {
                response_code: Constants::ERROR_CODE_VALIDATION,
                response_message: {
                  pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, 
                  beasiswa: beasiswa.errors.full_messages,
                  penggalangan_dana: penggalangan_dana.errors.full_messages
                },
                }, status: :ok
            end
          end
        end
      end
    end
  end

  def selectPenyaluranNonBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.penyaluran_non_beasiswa.where(id: params[:id]).first
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penerima Bantuan Dana Non Beasiswa tidak ada atau sudah dilakukan penyaluran" 
        }, status: :unprocessable_entity
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: pengajuan_bantuan.id).first
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Penerima Bantuan Dana Non Beasiswa tidak ada!" 
          }, status: :unprocessable_entity
      else
        if params[:is_penyaluran].blank?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "is_penyaluran tidak boleh kosong!"
            }, status: :unprocessable_entity
        else 
          if params[:is_penyaluran] != "true" and params[:is_penyaluran] != "false"
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "is_penyaluran hanya dapat true atau false!"
              }, status: :unprocessable_entity
          else
            if params[:is_penyaluran] == "true"
              status_penyaluran = Enums::StatusPenyaluran::DELIVERED
            else
              status_penyaluran = Enums::StatusPenyaluran::PENDING
            end
            pengajuan_bantuan.assign_attributes(status_penyaluran: status_penyaluran)
            if pengajuan_bantuan.save
              render json: {
                response_code: Constants::RESPONSE_SUCCESS,
                response_message: "Success",
                data: pengajuan_bantuan
                }, status: :ok
            end
          end
        end
      end
    end
  end

  def getTotalPengeluaran(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
    array_of_nominal_penyaluran = []
    penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
      if index > 0
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.rekapitulasi_beasiswa.where(:id => data).first
        beasiswa = Pengajuan::Beasiswa.where(:id => pengajuan_bantuan.beasiswa_id).first
        array_of_nominal_penyaluran << beasiswa.nominal_penyaluran
      end
    end
    total_pengeluaran = array_of_nominal_penyaluran.inject(0, :+)
    return total_pengeluaran
  end

  def getSaldoAwal
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_done_admin
    if not pengajuan_bantuan.present?
      saldo_awal = 0
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
      donasi = Penggalangan::Donasi.approved.where(:id => penggalangan_dana.donasi_id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      saldo_awal = total_donasi - penyaluran
    end
    return saldo_awal
  end

  def getTotalDonasi(penggalangan_dana_id)
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

  def getMonthRekapitulasiBeasiswa(penggalangan_dana_id)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(:id => penggalangan_dana_id).first
    start_date = penggalangan_dana.created_at
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.batch_beasiswa.where(:id => penggalangan_dana.pengajuan_bantuan_id[0]).first
    end_date = pengajuan_bantuan.waktu_galang_dana
    array_of_month = []
    while start_date <= end_date
      array_of_month << start_date.strftime('%B')
      start_date = start_date.next_month
    end
    return array_of_month
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
            donatur = User::Donatur.donatur_registered.where(:donasi_id => data_donation.id).first
            bank = Bank.where(:id => donatur.bank_id).first
            object_data_donasi = penggalangan_dana.attributes.merge({
              :pengajuan_bantuan_id => pengajuan_bantuan,
              :donasi_id => donatur.attributes.merge({
                :donasi_id => data_donation,
                :bank_id => bank,
              })
            })
            object_data_donasi["donatur"] = object_data_donasi.delete("donasi_id")
            data_donasi << object_data_donasi
          end
          
          donasi_penggalangan_dana = data_donasi.reverse
        else
          donatur = User::Donatur.donatur_registered.where(:donasi_id => donasi.first.id).first
          bank = Bank.where(:id => donatur.bank_id).first
          donasi_penggalangan_dana = penggalangan_dana.attributes.merge({
            :pengajuan_bantuan_id => pengajuan_bantuan,
            :donasi_id => donatur.attributes.merge({
              :donasi_id => donasi.first,
              :bank_id => bank,
            })
          })
          donasi_penggalangan_dana["donatur"] = donasi_penggalangan_dana.delete("donasi_id")
        end
  
        if params[:month].present?
          # Filter the response by the specified month
          month_filter = donasi_penggalangan_dana.select { |donasi| donasi[:updated_at].strftime('%B') == params[:month] }
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: month_filter
          }, status: :ok
        else
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: donasi_penggalangan_dana
          }, status: :ok
        end
      end
    end
  end
end

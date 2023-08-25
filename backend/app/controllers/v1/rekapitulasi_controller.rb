class V1::RekapitulasiController < ApplicationController
    # before_action :
  def getRekapitulasiBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
  
    if not penggalangan_dana.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Penggalangan Dana tidak ditemukan!"
      }, status: :unprocessable_entity
    else
      array_of_penerima_beasiswa = []
  
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        if penggalangan_dana.pengajuan_bantuan_id.length > 1
          penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
            if index > 0
              pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: data).first
              beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first
              bank = Bank.where(:id => pengajuan_bantuan.bank_id).first
              array_of_penerima_beasiswa << pengajuan_bantuan.attributes.merge({
                nominal_penyaluran: beasiswa.nominal_penyaluran,
                bulan_penyaluran: beasiswa.bulan_penyaluran,
                bank_id: bank
              })
            end
          end
          penerima_beasiswa = array_of_penerima_beasiswa
        else
          penerima_beasiswa = {}
        end
  
        # Handle params[:month] to filter the data accordingly
        if params[:month].present?
          # Filter the pengajuan_bantuan_id array by the specified month
          month_filter = penerima_beasiswa.select { |penerima| penerima["bulan_penyaluran"][0].strftime('%B') == params[:month] }
          if getMonthRekapitulasiBeasiswa(penggalangan_dana.id)[0] == params[:month]
            saldo_akhir = getSaldoAwal() + getTotalDonasi(penggalangan_dana.id, params[:month])
            saldo_awal = getSaldoAwal()
            total_pengeluaran = getTotalPengeluaran(penggalangan_dana.id, params[:month])
          else
			month_filter = []
            getMonthRekapitulasiBeasiswa(penggalangan_dana.id).each_with_index do |data_month, index_month|
              if data_month == params[:month]
                saldo_awal = getTotalDonasi(penggalangan_dana.id, getMonthRekapitulasiBeasiswa(penggalangan_dana.id)[index_month - 1]) - getTotalPengeluaran(penggalangan_dana.id, getMonthRekapitulasiBeasiswa(penggalangan_dana.id)[index_month - 1])
                saldo_akhir = saldo_awal - getTotalPengeluaran(penggalangan_dana.id, params[:month]) + getTotalDonasi(penggalangan_dana.id, params[:month])
                penerima_beasiswa.each_with_index do |data_penerima_beasiswa, index_penerima_beasiswa|
                  if data_penerima_beasiswa["bulan_penyaluran"][index_month - 1].present?
                    month_filter << data_penerima_beasiswa
                  end
                end
              end
            end
          end

          rekapitulasi_beasiswa = penggalangan_dana.attributes.merge({
            pengajuan_bantuan_id: month_filter,
            total_donasi: getTotalDonasi(penggalangan_dana.id, params[:month]),
            total_pengeluaran: getTotalPengeluaran(penggalangan_dana.id, params[:month]),
            saldo_awal: saldo_awal,
            saldo_akhir: saldo_akhir,
            daftar_bulan: getMonthRekapitulasiBeasiswa(penggalangan_dana.id),
            daftar_donasi: getApprovedDonasiByPenggalanganDana(penggalangan_dana.id, params[:month], return_json: false)
          })
        else
          # If params[:month] is not present, use the entire penerima_beasiswa array
          rekapitulasi_beasiswa = penggalangan_dana.attributes.merge({
            pengajuan_bantuan_id: penerima_beasiswa,
            total_donasi: getTotalDonasi(penggalangan_dana.id, params[:month]),
            total_pengeluaran: getTotalPengeluaran(penggalangan_dana.id, params[:month]),
            saldo_awal: getSaldoAwal(),
            saldo_akhir: getTotalDonasi(penggalangan_dana.id, params[:month]) - getTotalPengeluaran(penggalangan_dana.id, params[:month]),
            daftar_bulan: getMonthRekapitulasiBeasiswa(penggalangan_dana.id)
          })
        end
  
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
      render_error_response("Data Batch Beasiswa tidak ada!")
    end
    penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
    render_success_response(Constants::RESPONSE_SUCCESS, penggalangan_dana.pluck(:id), Constants::STATUS_OK)
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
              changeBulanPenyaluran(beasiswa)
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

  def changeBulanPenyaluran(beasiswa)
    next_month = beasiswa.updated_at.next_month.beginning_of_month
    beasiswa.bulan_penyaluran << next_month
    beasiswa.save!
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

  def getTotalPengeluaran(penggalangan_dana_id, month)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: penggalangan_dana_id).first
    array_of_beasiswa = []
    penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
      if index > 0
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.rekapitulasi_beasiswa.where(:id => data).first
        array_of_beasiswa << Pengajuan::Beasiswa.where(:id => pengajuan_bantuan.beasiswa_id).first
      end
    end
    beasiswa_filter = array_of_beasiswa.select { |data| data["bulan_penyaluran"][0].strftime('%B') == month }
    total_pengeluaran = beasiswa_filter.pluck(:nominal_penyaluran).inject(0, :+)
    return total_pengeluaran
  end

  def getSaldoAwal
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_done_admin
    if not pengajuan_bantuan.present?
      saldo_awal = 0
    else
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
      penggalangan_dana.pengajuan_bantuan_id.each_with_index do |data, index|
        if index > 0
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.done
        end
      end
      donasi = Penggalangan::Donasi.approved.where(:id => penggalangan_dana.donasi_id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      saldo_awal = total_donasi - penyaluran
    end
    return saldo_awal
  end

  def getTotalDonasi(penggalangan_dana_id, month)
    penggalangan_dana = Penggalangan::PenggalanganDana.where(_id: penggalangan_dana_id).first
    if not penggalangan_dana.donasi_id.present?
      total_donasi = 0
    else
      donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
      if not donasi.present?
        total_donasi = 0
      else
        donasi_filter = donasi.select { |data| data["updated_at"].strftime('%B') == month }
        total_donasi = donasi_filter.pluck(:nominal).inject(0, :+)
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

  def getApprovedDonasiByPenggalanganDana(penggalangan_dana_id = nil, month = nil, return_json: true)
    if penggalangan_dana_id == nil
      id_penggalangan_dana = params[:id]
    else
      id_penggalangan_dana = penggalangan_dana_id
    end
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: id_penggalangan_dana).first
  
    unless penggalangan_dana.present?
      response_data = "Data Penggalangan Dana tidak ditemukan!"
      return return_json ? render_error_response(response_data) : response_data
    end
  
    unless penggalangan_dana.donasi_id.present?
      response_data = "Belum ada donasi pada penggalangan dana ini!"
      return return_json ? render_error_response(response_data) : response_data
    end
  
    if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: penggalangan_dana.pengajuan_bantuan_id[0]).first
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(id: penggalangan_dana.pengajuan_bantuan_id).first
    end
  
    donasi = Penggalangan::Donasi.approved.where(:id.in => penggalangan_dana.donasi_id)
    unless donasi.present?
      response_data = "Tidak ada data donasi pada penggalangan dana ini!"
      return return_json ? render_error_response(response_data) : response_data
    end
  
    data_donasi = donasi.map do |data_donation|
      donatur = User::Donatur.donatur_registered.where(donasi_id: data_donation.id).first
      bank = Bank.where(id: donatur.bank_id).first
      object_data_donasi = penggalangan_dana.attributes.merge({
        pengajuan_bantuan_id: pengajuan_bantuan,
        donasi_id: donatur.attributes.merge({
          donasi_id: data_donation,
          bank_id: bank,
        })
      })
      object_data_donasi["donatur"] = object_data_donasi.delete("donasi_id")
      object_data_donasi
    end
    
    params_month = return_json ? params[:month] : month
    if params[:month].present?
      # Filter the response by the specified month
      month_filter = data_donasi.select { |donasi| donasi["donatur"]["donasi_id"]["waktu_berakhir"].strftime('%B') == params_month }
      response_data =  month_filter
    else
      response_data = {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: data_donasi
      }
    end
  
    return return_json ? render_success_response(Constants::RESPONSE_SUCCESS, response_data, Constants::STATUS_OK) : month_filter
  end
end

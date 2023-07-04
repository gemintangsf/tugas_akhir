class V1::Rekapitulasi::RekapitulasiController < ApplicationController
    # before_action :
  def getRekapitulasiDanaBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.
      render json: {
        response_code: 200,
        response_message: "cik!"
        }, status: :ok
    end
  end

  def getRekapitulasiDanaNonBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.in(status_pengajuan: "penyaluran").union.in(status_pengajuan: "done").where(jenis: "NonBeasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: 422,
        response_message: "Data Penerima Penyaluran Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
      render json: {
        response_code: 200,
        response_message: {pengajuan_bantuan: pengajuan_bantuan, non_beasiswa: non_beasiswa}
        }, status: :ok
    end
  end

  def getTotalPengeluaran
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: penyaluran
        }, status: :ok
    end
  end

  def getSaldoAwal
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id)
      total_donasi = donasi.pluck(:nominal).inject(0, :+)
      penyaluran = total_donasi - penggalangan_dana.total_nominal_terkumpul
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: penyaluran
        }, status: :ok
    end
  end

  def getSaldoAkhir
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id)
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

  def selectPenyaluranBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Batch Beasiswa tidak dapat ditemukan!"
        }, status: :unprocessable_entity
    else
      nominal_tersisa = penggalangan.total_nominal_terkumpul - params[:nominal_penyaluran]
      penggalangan_dana.assign_attributes({total_nominal_terkumpul: nominal_tersisa})
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
      donasi = Penggalangan::Donasi.approved.where(penggalangan_dana_id: penggalangan_dana.id).reverse
      donatur = User::Donatur.donatur_registered.where(:_id.in => donasi.pluck(:donatur_id)).reverse
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: {donatur: donatur, donasi: donasi}
        }, status: :ok
    end
  end
end

class V1::Pengajuan::PengajuanBantuanController < ApplicationController

  #mendapatkan durasi pendaftaran
  def getDurasiPengajuanBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(params[:jenis]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Pendaftaran beasiswa belum ada!" 
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).where(jenis: "Beasiswa").first
      if not pengajuan_bantuan.present?
        render json: {
          response_code: 422,
          response_message: "Pendaftaran Beasiswa tidak ditemukan" 
          }, status: :unprocessable_entity
      else
        start_date = pengajuan_bantuan.created_at.to_datetime
        end_date = pengajuan_bantuan.waktu_galang_dana.to_datetime
        default_duration = (end_date - start_date).to_i
        time_left = (end_date - DateTime.now).to_i
        duration_pengajuan = time_left - (default_duration.to_i - 30)
        render json: {
          response_code: 200, 
          response_message: "Success", 
          data: duration_pengajuan.to_s + " Hari Lagi"
          }, status: :ok
      end
    end
  end

  #Untuk membuat pengajuan bantuan dana beasiswa
  def createPengajuanBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Penggalangan Dana tidak ada!"
        }, status: :unprocessable_entity
    else
      if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id[0]).first  
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(id: penggalangan_dana.pengajuan_bantuan_id).first
      end
      if pengajuan_bantuan.jenis != "Beasiswa"
        render json: {
          response_code: 422,
          response_message: "Pengajuan Beasiswa tidak dapat ditemukan!"
          }, status: :unprocessable_entity
      else
        start_date = pengajuan_bantuan.created_at.to_datetime
        end_date = pengajuan_bantuan.waktu_galang_dana.to_datetime
        default_duration = (end_date - start_date).to_i
        time_left = (end_date - DateTime.now).to_i
        duration_pengajuan = time_left - (default_duration.to_i - 30)
        if duration_pengajuan < 1
          render json: {
            response_code: 422,
            response_message: "Pengajuan Bantuan Dana Beasiswa sudah ditutup!"
            }, status: :unprocessable_entity
        else
          pengajuan_beasiswa = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_beasiswa_params)
          pengajuan_beasiswa.assign_attributes({ 
            judul_galang_dana: pengajuan_bantuan.judul_galang_dana,
            waktu_galang_dana: pengajuan_bantuan.waktu_galang_dana,
            dana_yang_dibutuhkan: pengajuan_bantuan.dana_yang_dibutuhkan,
            jenis: pengajuan_bantuan.jenis,
            status_pengajuan: "new" 
          })
          beasiswa = Pengajuan::Beasiswa.new(beasiswa_params)
          beasiswa.assign_attributes({
            pengajuan_bantuan: pengajuan_beasiswa})
          if beasiswa.save and pengajuan_beasiswa.save
              render json: {
                  response_code: 201, 
                  response_message: "Success", 
                  data: {pengajuan_beasiswa: pengajuan_beasiswa, beasiswa: beasiswa},
                  }, status: :created
          else
              render json: {
                  response_code: 422,
                  response_message: {pengajuan_beasiswa: pengajuan_beasiswa.errors.full_messages, beasiswa: beasiswa.errors.full_messages}
                  }, status: :unprocessable_entity
          end
        end
      end
    end
  end

  #Untuk membuat pengajuan bantuan non dana beasiswa
  def createPengajuanNonBeasiswa
    pengajuanNonBeasiswa = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
    waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
    if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
      render json: {
        response_code: 422,
        response_message: "Tanggal harus lebih dari hari sekarang!"
        }, status: :unprocessable_entity
    else
      pengajuanNonBeasiswa.assign_attributes({ 
        waktu_galang_dana: waktu_galang_dana,                                    
        status_pengajuan: "new"                                    
        })
      non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
      non_beasiswa.assign_attributes({pengajuan_bantuan: pengajuanNonBeasiswa})
      if non_beasiswa.save and pengajuanNonBeasiswa.save
          render json: {
              response_code: 201, 
              response_message: "Success", 
              data: {pengaju: non_beasiswa.pengajuan_bantuan, non_beasiswa: non_beasiswa},
              }, status: :created
      else
          render json: {
              response_code: 422,
              response_message: {pengaju: pengajuanNonBeasiswa.errors.full_messages, non_beasiswa: non_beasiswa.errors.full_messages}
              }, status: :unprocessable_entity
      end
    end
  end

  #Untuk melakukan pengurutan beasiswa berdasarkan metode SAW
  def getCalonBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: "Beasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: 422,
        response_message: "Tidak ada daftar calon penerima bantuan dana Beasiswa"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(jenis: "Beasiswa").first
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id => pengajuan_bantuan.id).first
      if penggalangan_dana.total_pengajuan > pengajuan_bantuan.length
        render json: {
          response_code: 422,
          response_message: "Tidak dapat melakukan seleksi beasiswa! karena total pendaftar beasiswa kurang dari kuota beasiswa"
          }, status: :unprocessable_entity
      else
        if pengajuan_bantuan.length == 1
          render json: {
            response_code: 422,
            response_message: "Tidak dapat melakukan seleksi beasiswa! karena hanya terdapat 1 pendaftar"
            }, status: :unprocessable_entity
        else
          dataset_criteria =
          [
            "criteria": [
              [
                "code": "C1",
                "name": "Golongan UKT",
                "type": "Benefit",
                "weight": 3.5
              ],
              [
                "code": "C2",
                "name": "Beban Pengeluaran Keluarga",
                "type": "benefit",
                "weight": 3.5
              ],
              [
                "code": "C3",
                "name": "Penilaian Esai",
                "type": "benefit",
                "weight": 2
              ],
              [
                "code": "C4",
                "name": "Jumlah Tanggungan Keluarga",
                "type": "cost",
                "weight": 1
              ]
            ]
          ]
          dataset_alternatif = ["alternatif": []]
          dataset_json = dataset_criteria.to_json


        end
      end
    end
  end

  #Untuk melakukan approval pengajuan beasiswa
  def selectPengajuanBeasiswa
    penggalangan_dana = Penggalangan::PenggalanganDana.where(id: params[:penggalangan_dana_id]).first
    if not penggalangan_dana.present?
      render json: {
        response_code: 422,
        response_message: "Data Penggalangan Dana tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(id: params[:pengajuan_bantuan_id]).first
      if not pengajuan_bantuan.present?
        render json: {
          response_code: 422,
          response_message: "Data Pengajuan Baru tidak ditemukan!"
          }, status: :unprocessable_entity
      else
        beasiswa = Pengajuan::Beasiswa.where(pengajuan_bantuan_id: pengajuan_bantuan.id).first
        if params[:is_approve] == "true"
          status_pengajuan = "approved"
        else
          status_pengajuan = "rejected"
        end
        pengajuan_bantuan.assign_attributes({ status_pengajuan: status_pengajuan})
        trough_id = [penggalangan_dana.pengajuan_bantuan_id] << pengajuan_bantuan.id
        penggalangan_dana.assign_attributes({ pengajuan_bantuan_id: trough_id })
        if penggalangan_dana.save and pengajuan_bantuan.save
          render json: {
          response_code: 200, 
          response_message: "Success", 
          data: {pengajuan_bantuan: pengajuan_bantuan, beasiswa: beasiswa}
          }, status: :ok
        else
          render json: {
          response_code: 422,
          response_message: {penggalangan_dana: penggalangan_dana.errors.full_messages, pengajuan_bantuan: pengajuan_bantuan.errors.full_messages}
          }, status: :unprocessable_entity
        end
      end
    end
  end

  #Untuk melakukan approval pengajuan non-beasiswa
  def selectPengajuanNonBeasiswa
    pengajuan_non_beasiswa = Pengajuan::PengajuanBantuan.pengajuan_baru.where(_id: params[:id]).first
    if not pengajuan_non_beasiswa.present?
      render json: {
        response_code: 422,
        response_message: "Data Pengajuan Baru tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.where(pengajuan_bantuan_id: pengajuan_non_beasiswa.id).first
      if params[:is_approve] == "true"
        status_pengajuan = "approved"
      else
        status_pengajuan = "rejected"
      end
      pengajuan_non_beasiswa.assign_attributes({ status_pengajuan: status_pengajuan})
      penggalangan_non_beasiswa = Penggalangan::PenggalanganDana.new(
        total_pengajuan: "1",
        total_nominal_terkumpul: 0,
        pengajuan_bantuan: pengajuan_non_beasiswa
      )
      if penggalangan_non_beasiswa.save and pengajuan_non_beasiswa.save
        render json: {
        response_code: 201, 
        response_message: "Success", 
        data: {pengajuan_bantuan: pengajuan_non_beasiswa, non_beasiswa: non_beasiswa}
        }, status: :created
      else
        render json: {
        response_code: 422,
        response_message: pengajuan_non_beasiswa.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  end

  def getPengajuan
    if params[:jenis] != "Beasiswa" and params[:jenis] != "NonBeasiswa"
      render json: {
        response_code: 422,
        response_message: "Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa" 
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.in(status_pengajuan: "new").union.in(status_pengajuan: "approved").where(jenis: params[:jenis])
      if not pengajuan_bantuan.present?
        render json: {
          response_code: 422,
          response_message: "Tidak ada data Pengajuan Baru Bantuan Dana Beasiswa!" 
          }, status: :unprocessable_entity
      else
        array_of_pengajuan_bantuan_id = []
        beasiswa = []
        non_beasiswa = []
        if params[:jenis] == "Beasiswa"
          if pengajuan_bantuan.length > 1
            pengajuan_bantuan.pluck(:id).each_with_index do |data, index|
              if index > 0
                array_of_pengajuan_bantuan_id << data
              end
            end
          end
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.where(:_id.in => array_of_pengajuan_bantuan_id)
          beasiswa = Pengajuan::Beasiswa.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
        else
          non_beasiswa = Pengajuan::NonBeasiswa.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:id))
        end
        render json: {
          response_code: 200, 
          response_message: "Success", 
          data: {pengajuan_bantuan: pengajuan_bantuan, detail: [beasiswa: beasiswa, non_beasiswa: non_beasiswa]}
          }, status: :ok
      end
    end
  end

  def getPengajuanNonBeasiswaByKategori
    if params[:kategori] != "Medis" and params[:kategori] != "Bencana"
      render json: {
        response_code: 422,
        response_message: "Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis atau Bencana"
        }, status: :unprocessable_entity
    else
      non_beasiswa_by_category = Pengajuan::NonBeasiswa.where(kategori: params[:kategori])
      if not non_beasiswa_by_category.present?
        render json: {
          response_code: 422,
          response_message: "Tidak ada data Pengajuan Bantuan Dana Non Beasiswa berdasarkan kategori #{params[:kategori]}!" 
          }, status: :unprocessable_entity
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(:_id.in => non_beasiswa.pluck(:pengajuan_bantuan_id))
        render json: {
          response_code: 200, 
          response_message: "Success", 
          data: {pengajuan_bantuan: pengajuan_bantuan, non_beasiswa: non_beasiswa_by_category}
          }, status: :ok
      end
    end
  end

  def getPenerimaBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.penerima_beasiswa.where(jenis: "Beasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: 422,
        response_message: "Tidak ada data Penerima Bantuan Dana Beasiswa!" 
        }, status: :unprocessable_entity
    else
      beasiswa = Pengajuan::Beasiswa.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:_id))
      penerima_beasiswa = Pengajuan::PengajuanBantuan.where(:_id.in => beasiswa.pluck(:pengajuan_bantuan_id))
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: {penerima_beasiswa: penerima_beasiswa, beasiswa: beasiswa}
        }, status: :ok
    end
  end

  def selectLanjutBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.done.where(id: params[:id]).first
    if not pengajuan_bantuan.present?
      render json: {
        response_code: 422,
        response_message: "Penerima Bantuan Dana Beasiswa tidak ada!" 
        }, status: :unprocessable_entity
    else
      beasiswa = Pengajuan::Beasiswa.where(:pengajuan_bantuan_id=> pengajuan_bantuan.id).first
      penerima_beasiswa = Pengajuan::PengajuanBantuan.where(:_id=> beasiswa.id).first
      if params[:status] == "continue"
        status_pengajuan == "continue"
      else
        status_pengajuan == "deleted"
      end
      penerima_beasiswa.assign_attributes(status_pengajuan: status_pengajuan)
      if penerima_beasiswa.save
        render json: {
          response_code: 200, 
          response_message: "Success", 
          data: {penerima_beasiswa: penerima_beasiswa, beasiswa: beasiswa}
          }, status: :ok
      else
        render json: {
          response_code: 422,
          response_message: penerima_beasiswa.errors.full_messages 
          }, status: :unprocessable_entity
      end
    end
  end

  def getLanjutBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.continue.where(jenis: "Beasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: 422,
        response_message: "Tidak ada data Lanjut Penerima Bantuan Dana Beasiswa!" 
        }, status: :unprocessable_entity
    else
      beasiswa = Pengajuan::Beasiswa.where(:pengajuan_bantuan_id.in => pengajuan_bantuan.pluck(:_id))
      lanjut_beasiswa = Pengajuan::PengajuanBantuan.where(:_id.in => beasiswa.pluck(:pengajuan_bantuan_id))
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: {lanjut_beasiswa: lanjut_beasiswa, beasiswa: beasiswa}
        }, status: :ok
    end
  end

  def getTotalCalonPengajuan
    if params[:jenis] != "Beasiswa" and params[:jenis] != "NonBeasiswa"
      render json: {
        response_code: 422,
        response_message: "Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: params[:jenis])
      total_calon_pengajuan = pengajuan_bantuan.length
      render json: {
        response_code: 200, 
        response_message: "Success", 
        data: total_calon_pengajuan
        }, status: :ok
    end
    
  end

  private
  #form pengaju
  def pengajuan_bantuan_params
    params.permit(:nama, 
      :no_identitas_pengaju, 
      :no_telepon, 
      :nomor_rekening, 
      :nama_pemilik_rekening, 
      :bank,
      :judul_galang_dana,
      :waktu_galang_dana,
      :deskripsi,
      :dana_yang_dibutuhkan,
      :jenis
    )
  end

  def pengajuan_bantuan_beasiswa_params
    params.permit(
      :nama , 
      :no_identitas_pengaju, 
      :no_telepon, 
      :nomor_rekening, 
      :nama_pemilik_rekening, 
      :bank,
      :deskripsi,
    )
  end
  #form beasiswa
  def beasiswa_params
    params.permit(:golongan_ukt, 
      :kuitansi_pembayaran_ukt, 
      :gaji_orang_tua, 
      :bukti_slip_gaji_orang_tua, 
      :esai, 
      :jumlah_tanggungan_keluarga,
      :biaya_transportasi,
      :biaya_konsumsi,
      :biaya_internet, 
      :biaya_kos, 
      :total_pengeluaran_keluarga,
      :rincian_pengeluaran_keluarga,
    )
  end
  #form non beasiswa
  def non_beasiswa_params
    params.permit(:nama_penerima, 
      :no_identitas_penerima, 
      :no_telepon_penerima, 
      :bukti_butuh_bantuan,
      :kategori,
    )
  end
end

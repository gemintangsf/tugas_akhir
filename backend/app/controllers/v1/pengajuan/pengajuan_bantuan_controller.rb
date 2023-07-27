class V1::Pengajuan::PengajuanBantuanController < ApplicationController

  #mendapatkan durasi pendaftaran
  def getDurasiPengajuanBeasiswa
    pengajuan_beasiswa_by_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
    if not pengajuan_beasiswa_by_admin.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Pendaftaran Bantuan Dana Beasiswa belum dibuka!" 
        }, status: :unprocessable_entity
    else
      start_date = pengajuan_beasiswa_by_admin.created_at.to_datetime
      end_date = pengajuan_beasiswa_by_admin.waktu_galang_dana.to_datetime
      default_duration = (end_date - start_date).to_i
      time_left = (end_date - DateTime.now).to_i
      duration_pengajuan = time_left - (default_duration.to_i - 30)
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: duration_pengajuan.to_s + " Hari Lagi"
        }, status: :ok
    end
  end

  #Untuk membuat pengajuan bantuan dana beasiswa
  def createPengajuanBeasiswa
    pengajuan_beasiswa_by_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
    if not pengajuan_beasiswa_by_admin.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!"
        }, status: :unprocessable_entity
    else
      start_date = pengajuan_beasiswa_by_admin.created_at.to_datetime
      end_date = pengajuan_beasiswa_by_admin.waktu_galang_dana.to_datetime
      default_duration = (end_date - start_date).to_i
      time_left = (end_date - DateTime.now).to_i
      duration_pengajuan = time_left - (default_duration.to_i - 30)
      if duration_pengajuan < 1
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Pengajuan Bantuan Dana Beasiswa sudah ditutup!"
          }, status: :unprocessable_entity
      else
        is_civitas = CivitasAkademika.where(nomor_induk: params[:no_identitas_pengaju]).first
        if not is_civitas.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "NIM tidak dapat ditemukan!"
            }, status: :unprocessable_entity
        else
          is_pengajuan = Pengajuan::PengajuanBantuan.not.where(status_pengajuan: Enums::StatusPengajuan::DONE).where(no_identitas_pengaju: params[:no_identitas_pengaju]).where(jenis: "Beasiswa").first
          if is_pengajuan.present?
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "Pengajuan Bantuan Dana Beasiswa sudah dilakukan!"
              }, status: :unprocessable_entity
          else
            beasiswa = Pengajuan::Beasiswa.new(beasiswa_params)
            pengajuan_beasiswa = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_beasiswa_params)
            bank = Bank.new(bank_params)
            pengajuan_beasiswa.assign_attributes({ 
              nama: is_civitas.nama,
              bank: bank,
              no_identitas_pengaju: params[:no_identitas_pengaju],
              judul_galang_dana: pengajuan_beasiswa_by_admin.judul_galang_dana,
              waktu_galang_dana: pengajuan_beasiswa_by_admin.waktu_galang_dana,
              dana_yang_dibutuhkan: pengajuan_beasiswa_by_admin.dana_yang_dibutuhkan,
              jenis: pengajuan_beasiswa_by_admin.jenis,
              beasiswa: beasiswa,
              status_pengajuan: Enums::StatusPengajuan::NEW,
              status_penyaluran: Enums::StatusPenyaluran::NULL
            })
            if beasiswa.save and pengajuan_beasiswa.save and bank.save
                render json: {
                    response_code: Constants::RESPONSE_CREATED, 
                    response_message: "Success", 
                    data: {pengajuan_beasiswa: pengajuan_beasiswa, beasiswa: beasiswa, bank: bank},
                    }, status: :created
            else
                render json: {
                    response_code: Constants::ERROR_CODE_VALIDATION,
                    response_message: {pengajuan_beasiswa: pengajuan_beasiswa.errors.full_messages, beasiswa: beasiswa.errors.full_messages, bank: bank.errors.full_messages}
                    }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end

  #Untuk membuat pengajuan bantuan non dana beasiswa
  def createPengajuanNonBeasiswa
    is_civitas_pengaju = CivitasAkademika.where(nomor_induk: params[:no_identitas_pengaju]).first
    is_civitas_penerima = CivitasAkademika.where(nomor_induk: params[:no_identitas_penerima]).first
    if not is_civitas_pengaju.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "NIM/NIP Penanggung Jawab tidak dapat ditemukan!"
        }, status: :unprocessable_entity
    elsif not is_civitas_penerima.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "NIM/NIP Penerima tidak dapat ditemukan!"
        }, status: :unprocessable_entity
    elsif not is_civitas_pengaju.present? and is_civitas_penerima.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "NIM/NIP Penanggung Jawab dan Penerima tidak dapat ditemukan!"
        }, status: :unprocessable_entity
    elsif is_civitas_pengaju == is_civitas_penerima
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penanggung Jawab harus berbeda!"
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
      non_beasiswa.assign_attributes(:nama_penerima => is_civitas_penerima.nama)
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
      bank = Bank.new(bank_params)
      waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
      if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tanggal harus lebih dari hari sekarang!"
          }, status: :unprocessable_entity
      else
        pengajuan_bantuan.assign_attributes({ 
          nama: is_civitas_pengaju.nama,
          bank: bank,
          jenis: "NonBeasiswa",
          non_beasiswa: non_beasiswa,
          waktu_galang_dana: waktu_galang_dana,                                    
          status_pengajuan: Enums::StatusPengajuan::NEW,
          status_penyaluran: Enums::StatusPenyaluran::NULL             
          })
        if non_beasiswa.save and pengajuan_bantuan.save and bank.save
            render json: {
                response_code: Constants::RESPONSE_CREATED, 
                response_message: "Success", 
                data: {pengajuan_bantuan: pengajuan_bantuan, non_beasiswa: non_beasiswa, bank: bank},
                }, status: :created
        else
            render json: {
                response_code: Constants::ERROR_CODE_VALIDATION,
                response_message: {pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, non_beasiswa: non_beasiswa.errors.full_messages, bank: bank.errors.full_messages}
                }, status: :unprocessable_entity
        end
      end
    end
  end

  #Untuk melakukan pengurutan beasiswa berdasarkan metode SAW
  def getCalonBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: "Beasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada daftar calon penerima bantuan dana Beasiswa"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.penggalangan_dana.where(jenis: "Beasiswa").first
      penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id => pengajuan_bantuan.id).first
      if penggalangan_dana.total_pengajuan > pengajuan_bantuan.length
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak dapat melakukan seleksi beasiswa! karena total pendaftar beasiswa kurang dari kuota beasiswa"
          }, status: :unprocessable_entity
      else
        if pengajuan_bantuan.length == 1
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
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
          pengajuan_bantuan.each_with_index do |data, index|
            beasiswa = Pengajuan::Beasiswa.where(id: data.beasiswa_id).first
            dataset_alternatif = [
              "alternatif": [
                "id": index + 1,
                "name": "ke #{index + 1}",
                "C1": beasiswa.golongan_ukt,
                "C2": (beasiswa.gaji_orang_tua - beasiswa.total_pengeluaran_keluarga).abs,
                "C3": params[:penilaian_essai],
                "C4": beasiswa.jumlah_tanggungan_keluarga
              ]
            ]
          end
          dataset_json = dataset_criteria.to_json


        end
      end
    end
  end

  def createPenilaianEsai
    if not params[:id].present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "id tidak boleh kosong!"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: "Beasiswa").where(id: params[:id]).first
      if not pengajuan_bantuan.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Pengajuan Bantuan tidak dapat ditemukan!"
          }, status: :unprocessable_entity
      else
        beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first
        if params[:penilaian_esai].blank?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Penilaian Esai tidak boleh kosong!"
            }, status: :unprocessable_entity
        else
          if params[:penilaian_esai] != "Kurang" and params[:penilaian_esai] != "Cukup" and params[:penilaian_esai] != "Baik" and params[:penilaian_esai] != "SangatBaik"
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "Penilaian Esai #{params[:penilaian_esai]} tidak ada!, hanya ada Kurang/Cukup/Baik/SangatBaik"
              }, status: :unprocessable_entity
          else
            if params[:penilaian_esai] == "Kurang"
              penilaian_esai = Enums::PenilaianEsai::LESS
            elsif params[:penilaian_esai] == "Cukup"
              penilaian_esai = Enums::PenilaianEsai::ENOUGH
            elsif params[:penilaian_esai] == "Baik"
              penilaian_esai = Enums::PenilaianEsai::GOOD
            else
              penilaian_esai = Enums::PenilaianEsai::VERYGOOD
            end
            beasiswa.assign_attributes(penilaian_esai: penilaian_esai)
            if beasiswa.save
              render json: {
                response_code: Constants::RESPONSE_SUCCESS, 
                response_message: "Success", 
                data: {pengajuan_bantuan: pengajuan_bantuan, beasiswa: beasiswa}
              }, status: :ok
            else
              render json: {
                response_code: Constants::ERROR_CODE_VALIDATION,
                response_message: beasiswa.errors.full_messages
                }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end

  #Untuk melakukan approval pengajuan beasiswa
  def selectPengajuanBeasiswa
    pengajuan_beasiswa_by_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
    penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id => pengajuan_beasiswa_by_admin.id).first
    if not params[:id].present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "id tidak boleh kosong!"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(id: params[:id]).first
      if not pengajuan_bantuan.present?
        render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Data Pengajuan Baru tidak ditemukan!"
          }, status: :unprocessable_entity
      else
        beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first
        if beasiswa.penilaian_esai == nil
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Penilaian Esai tidak boleh kosong!"
          }, status: :unprocessable_entity
        else
          if params[:is_approve].blank?
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "is_approve tidak boleh kosong!"
              }, status: :unprocessable_entity
          else 
            if params[:is_approve] != "true" and params[:is_approve] != "false"
              render json: {
                response_code: Constants::ERROR_CODE_VALIDATION,
                response_message: "is_approve hanya dapat true atau false!"
                }, status: :unprocessable_entity
            else
              if params[:is_approve] == "true"
                status_pengajuan = Enums::StatusPengajuan::APPROVED
                status_penyaluran = Enums::StatusPenyaluran::NEW
                beasiswa.assign_attributes(nominal_penyaluran: Constants::NOMINAL_PENYALURAN)
              else
                status_pengajuan = Enums::StatusPengajuan::REJECTED
                status_penyaluran = Enums::StatusPenyaluran::NULL
              end
              pengajuan_bantuan.assign_attributes({ 
                status_pengajuan: status_pengajuan,
                status_penyaluran: status_penyaluran
                })
              array_of_pengajuan_bantuan_id = []
              if penggalangan_dana.pengajuan_bantuan_id.kind_of?(Array)
                penggalangan_dana.pengajuan_bantuan_id << pengajuan_bantuan.id
              else
                array_of_pengajuan_bantuan_id << penggalangan_dana.pengajuan_bantuan_id
                array_of_pengajuan_bantuan_id << pengajuan_bantuan.id
                penggalangan_dana.assign_attributes({pengajuan_bantuan_id: array_of_pengajuan_bantuan_id})
              end
              if penggalangan_dana.save!(:validate => false) and pengajuan_bantuan.save and beasiswa.save
                render json: {
                  response_code: Constants::RESPONSE_SUCCESS, 
                  response_message: "Success", 
                  data: {pengajuan_bantuan: pengajuan_bantuan, beasiswa: beasiswa}
                }, status: :ok
              else
                render json: {
                  response_code: Constants::ERROR_CODE_VALIDATION,
                  response_message: {penggalangan_dana: penggalangan_dana.errors.full_messages, pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, beasiswa: beasiswa.errors.full_messages}
                }, status: :unprocessable_entity
              end
            end
          end
        end
      end
    end
  end

  #Untuk melakukan approval pengajuan non-beasiswa
  def selectPengajuanNonBeasiswa
    pengajuan_non_beasiswa = Pengajuan::PengajuanBantuan.pengajuan_baru.where(_id: params[:id]).first
    if not pengajuan_non_beasiswa.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Data Pengajuan Baru tidak ditemukan!"
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.where(id: pengajuan_non_beasiswa.non_beasiswa_id).first
      if params[:is_approve].blank?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "is_approve tidak boleh kosong!"
          }, status: :unprocessable_entity
      else 
        if params[:is_approve] != "true" and params[:is_approve] != "false"
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "is_approve hanya dapat true atau false!"
            }, status: :unprocessable_entity
        else
          if params[:is_approve] == "true"
            status_pengajuan = Enums::StatusPengajuan::APPROVED
            status_penyaluran = Enums::StatusPengajuan::NEW
          else
            status_pengajuan = Enums::StatusPengajuan::REJECTED
            status_penyaluran = Enums::StatusPengajuan::NULL
          end
          pengajuan_non_beasiswa.assign_attributes({ 
            status_pengajuan: status_pengajuan,
            status_penyaluran: status_penyaluran
            })
          penggalangan_non_beasiswa = Penggalangan::PenggalanganDana.new(
            total_pengajuan: "1",
            total_nominal_terkumpul: 0,
            pengajuan_bantuan: pengajuan_non_beasiswa
          )
          if penggalangan_non_beasiswa.save and pengajuan_non_beasiswa.save
            render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: {pengajuan_bantuan: pengajuan_non_beasiswa, non_beasiswa: non_beasiswa}
            }, status: :ok
          else
            render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: pengajuan_non_beasiswa.errors.full_messages
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def getPengajuan
    if params[:jenis] != "Beasiswa" and params[:jenis] != "NonBeasiswa"
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa" 
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: params[:jenis])
      bank = Bank.where(:id.in => pengajuan_bantuan.pluck(:bank_id))
      if not pengajuan_bantuan.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada data Pengajuan Baru Bantuan Dana #{params[:jenis]}!" 
          }, status: :unprocessable_entity
      else
        array_of_id = []
        data_pengajuan_beasiswa = []
        data_pengajuan_non_beasiswa = []
        if pengajuan_bantuan.length > 1
          if params[:jenis] == "Beasiswa"
            pengajuan_bantuan.each_with_index do |data, index|
              array_of_id << data.beasiswa_id
            end
            beasiswa = Pengajuan::Beasiswa.where(:id.in => array_of_id)
            pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
              beasiswa.each_with_index do |data_beasiswa, index_beasiswa|
                if index_pengajuan_bantuan == index_beasiswa
                  bank = Bank.where(:id => data_pengajuan.bank_id).first
                  data_pengajuan_beasiswa << data_pengajuan.attributes.merge({
                    :beasiswa_id => data_beasiswa,
                    :bank_id => bank
                    })
                end
              end
            end
            pengajuan_baru = data_pengajuan_beasiswa.reverse
          else
            pengajuan_bantuan.each_with_index do |data, index|
              array_of_id << data.non_beasiswa
            end
            non_beasiswa = Pengajuan::NonBeasiswa.where(:id.in => array_of_id)
            pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
              non_beasiswa.each_with_index do |data_non_beasiswa, index_non_beasiswa|
                if index_pengajuan_bantuan == index_non_beasiswa
                  bank = Bank.where(:id => data_pengajuan.bank_id).first
                  data_pengajuan_non_beasiswa << data_pengajuan.attributes.merge({
                    :non_beasiswa_id => data_non_beasiswa,
                    :bank_id => bank
                    })
                end
              end
            end
            pengajuan_baru = data_pengajuan_non_beasiswa.reverse
          end
        else
          if params[:jenis] == "Beasiswa"
            beasiswa = Pengajuan::Beasiswa.where(:id => pengajuan_bantuan.first.beasiswa_id).first
            pengajuan_baru = pengajuan_bantuan.first.attributes.merge({
              :beasiswa_id => beasiswa,
              :bank_id => bank.first
              })
          else
            non_beasiswa = Pengajuan::NonBeasiswa.where(:id => pengajuan_bantuan.first.non_beasiswa_id).first
            pengajuan_baru = pengajuan_bantuan.first.attributes.merge({
              :non_beasiswa_id => non_beasiswa,
              :bank_id => bank.first
              })
          end
        end
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: pengajuan_baru
          }, status: :ok
      end
    end
  end

  def getPengajuanNonBeasiswaByKategori
    if params[:kategori].blank?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Kategori tidak boleh kosong!"
        }, status: :unprocessable_entity
    else
      if params[:kategori] != "Medis" and params[:kategori] != "Bencana" and params[:kategori] != "Duka"
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis/Bencana/Duka"
          }, status: :unprocessable_entity
      else
        non_beasiswa = Pengajuan::NonBeasiswa.where(kategori: params[:kategori])
        if not non_beasiswa.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada data Pengajuan Bantuan Dana Non Beasiswa berdasarkan kategori #{params[:kategori]}!" 
            }, status: :unprocessable_entity
        else
          pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(:non_beasiswa_id.in => non_beasiswa.pluck(:id))
          if not pengajuan_bantuan.present?
            render json: {
              response_code: Constants::ERROR_CODE_VALIDATION,
              response_message: "Tidak ada data pengajuan baru Non Beasiswa berdasarkan kategori #{params[:kategori]}!" 
              }, status: :unprocessable_entity
          else
            non_beasiswa_new = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_bantuan.pluck(:non_beasiswa_id))
            data_pengajuan_non_beasiswa = []
            if pengajuan_bantuan.length > 1
              pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
                non_beasiswa_new.each_with_index do |data_non_beasiswa, index_non_beasiswa|
                  if index_pengajuan_bantuan == index_non_beasiswa
                    bank = Bank.where(:id => data_pengajuan.bank_id).first
                    data_pengajuan_non_beasiswa << data_pengajuan.attributes.merge({
                      :non_beasiswa_id => data_non_beasiswa,
                      :bank_id => bank
                      })
                  end
                end
              end
              new_data_pengajuan = data_pengajuan_non_beasiswa.reverse
            else
              bank = Bank.where(:id => pengajuan_bantuan.first.bank_id).first
              new_data_pengajuan = pengajuan_bantuan.first.attributes.merge({
                :non_beasiswa_id => non_beasiswa_new,
                :bank_id => bank
                })
            end
            render json: {
              response_code: Constants::RESPONSE_SUCCESS, 
              response_message: "Success", 
              data: new_data_pengajuan
              }, status: :ok
          end
        end
      end
    end
  end

  def getPenerimaBantuanDana
    if params[:jenis].blank?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Jenis tidak boleh kosong!" 
        }, status: :unprocessable_entity
    else
      if params[:jenis] != "Beasiswa" and params[:jenis] != "NonBeasiswa"
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa" 
          }, status: :unprocessable_entity
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_approved.where(jenis: params[:jenis])
        if not pengajuan_bantuan.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada data Penerima Bantuan Dana #{params[:jenis]}!" 
            }, status: :unprocessable_entity
        else
          array_of_id = []
          data_pengajuan_beasiswa = []
          data_pengajuan_non_beasiswa = []
          if pengajuan_bantuan.length > 1
            if params[:jenis] == "Beasiswa"
              pengajuan_bantuan.each_with_index do |data, index|
                array_of_id << data.beasiswa_id
              end
              beasiswa = Pengajuan::Beasiswa.where(:id.in => array_of_id)
              pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
                beasiswa.each_with_index do |data_beasiswa, index_beasiswa|
                  if index_pengajuan_bantuan == index_beasiswa
                    bank = Bank.where(:id => data_pengajuan.bank_id).first
                    data_pengajuan_beasiswa << data_pengajuan.attributes.merge({
                      :beasiswa_id => data_beasiswa,
                      :bank_id => bank
                      })
                  end
                end
              end
              penerima_bantuan = data_pengajuan_beasiswa.reverse
            else
              pengajuan_bantuan.each_with_index do |data, index|
                array_of_id << data.non_beasiswa
              end
              non_beasiswa = Pengajuan::NonBeasiswa.where(:id.in => array_of_id)
              pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
                non_beasiswa.each_with_index do |data_non_beasiswa, index_non_beasiswa|
                  if index_pengajuan_bantuan == index_non_beasiswa
                    bank = Bank.where(:id => data_pengajuan.bank_id).first
                    data_pengajuan_non_beasiswa << data_pengajuan.attributes.merge({
                      :non_beasiswa_id => data_non_beasiswa,
                      :bank_id => bank
                      })
                  end
                end
              end
              penerima_bantuan = data_pengajuan_non_beasiswa.reverse
            end
          else
            bank = Bank.where(:id => pengajuan_bantuan.first.bank_id).first
            if params[:jenis] == "Beasiswa"
              beasiswa = Pengajuan::Beasiswa.where(:id => pengajuan_bantuan.first.beasiswa_id).first
              bank = Bank.where(:id => pengajuan_bantuan.first.bank_id).first
              penerima_bantuan = pengajuan_bantuan.first.attributes.merge({
                :beasiswa_id => beasiswa,
                :bank_id => bank
                })
            else
              non_beasiswa = Pengajuan::NonBeasiswa.where(:id => pengajuan_bantuan.first.non_beasiswa_id).first
              penerima_bantuan = pengajuan_bantuan.first.attributes.merge({
                :non_beasiswa_id => non_beasiswa,
                :bank_id => bank
                })
            end
          end
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: penerima_bantuan
            }, status: :ok
        end
      end
    end
  end

  def getPenerimaNonBeasiswaByKategori
    if params[:kategori] != "Medis" and params[:kategori] != "Bencana" and params[:kategori] != "Duka"
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Kategori #{params[:kategori]} tidak ada!, Kategori hanya Medis/Bencana/Duka"
        }, status: :unprocessable_entity
    else
      non_beasiswa = Pengajuan::NonBeasiswa.where(kategori: params[:kategori])
      if not non_beasiswa.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Tidak ada data Pengajuan Bantuan Dana Non Beasiswa berdasarkan kategori #{params[:kategori]}!" 
          }, status: :unprocessable_entity
      else
        pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_approved.where(:non_beasiswa_id.in => non_beasiswa.pluck(:id))
        if not pengajuan_bantuan.present?
          render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada data pengajuan baru Non Beasiswa berdasarkan kategori #{params[:kategori]}!" 
            }, status: :unprocessable_entity
        else
          non_beasiswa_new = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_bantuan.pluck(:non_beasiswa_id))
          data_pengajuan_non_beasiswa = []
          if pengajuan_bantuan.length > 1
            pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
              non_beasiswa_new.each_with_index do |data_non_beasiswa, index_non_beasiswa|
                if index_pengajuan_bantuan == index_non_beasiswa
                  data_pengajuan_non_beasiswa << data_pengajuan.attributes.merge(:non_beasiswa_id => data_non_beasiswa)
                end
              end
            end
            new_data_pengajuan = data_pengajuan_non_beasiswa.reverse
          else
            new_data_pengajuan = pengajuan_bantuan.first.attributes.merge(:non_beasiswa_id => non_beasiswa_new)
          end
          render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success", 
            data: new_data_pengajuan
            }, status: :ok
        end
      end
    end
  end

  def selectLanjutBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.done.where(id: params[:id]).first
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Penerima Bantuan Dana Beasiswa tidak ada!" 
        }, status: :unprocessable_entity
    else
      beasiswa = Pengajuan::Beasiswa.where(:id=> pengajuan_bantuan.beasiswa_id).first
      penerima_beasiswa = Pengajuan::PengajuanBantuan.where(:beasiswa_id=> beasiswa.id).first
      if params[:status] == "continue"
        status_pengajuan == "continue"
      else
        status_pengajuan == "deleted"
      end
      penerima_beasiswa.assign_attributes(status_pengajuan: status_pengajuan)
      if penerima_beasiswa.save
        render json: {
          response_code: Constants::RESPONSE_SUCCESS, 
          response_message: "Success", 
          data: {penerima_beasiswa: penerima_beasiswa, beasiswa: beasiswa}
          }, status: :ok
      else
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: penerima_beasiswa.errors.full_messages 
          }, status: :unprocessable_entity
      end
    end
  end

  def getLanjutBeasiswa
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.continue.where(jenis: "Beasiswa")
    if not pengajuan_bantuan.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Tidak ada data Lanjut Penerima Bantuan Dana Beasiswa!" 
        }, status: :unprocessable_entity
    else
      beasiswa = Pengajuan::Beasiswa.where(:id.in => pengajuan_bantuan.pluck(:beasiswa_id))
      lanjut_beasiswa = Pengajuan::PengajuanBantuan.where(:beasiswa_id.in => beasiswa.pluck(:id))
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: {lanjut_beasiswa: lanjut_beasiswa, beasiswa: beasiswa}
        }, status: :ok
    end
  end

  def getTotalCalonPengajuan
    if params[:jenis] != "Beasiswa" and params[:jenis] != "NonBeasiswa"
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa"
        }, status: :unprocessable_entity
    else
      pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: params[:jenis])
      total_calon_pengajuan = pengajuan_bantuan.length
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: total_calon_pengajuan
        }, status: :ok
    end
  end

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
          total_donasi: V1::Penggalangan::PenggalanganDanaController.new.getNominalTerkumpulPenggalanganDana(penggalangan_dana.id),
          total_pengeluaran: V1::Penggalangan::PenggalanganDanaController.new.getTotalPengeluaran(penggalangan_dana.id),
          saldo_awal: V1::Penggalangan::PenggalanganDanaController.new.getSaldoAwal,
          saldo_akhir: V1::Penggalangan::PenggalanganDanaController.new.getSaldoAkhir(penggalangan_dana.id)
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

  def getTotalPenerimaBantuan
    pengajuan_bantuan_approved = Pengajuan::PengajuanBantuan.pengajuan_approved
    if not pengajuan_bantuan_approved.present?
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: 0
      }, status: :ok
    else
      total_pengajuan_approved = pengajuan_bantuan_approved.length
      pengajuan_bantuan_done = Pengajuan::PengajuanBantuan.done
      if not pengajuan_bantuan_done.present?
        total_pengajuan_done = 0
      else
        total_pengajuan_done = pengajuan_bantuan_done.length
      end
      total_pengajuan = total_pengajuan_approved + total_pengajuan_done
      render json: {
        response_code: Constants::RESPONSE_SUCCESS, 
        response_message: "Success", 
        data: {penerima_bantuan_admin: total_pengajuan_approved, penerima_bantuan_penggalangan_dana: total_pengajuan}
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

  private
  #form pengaju
  def pengajuan_bantuan_params
    params.permit(:nama, 
      :no_identitas_pengaju, 
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

  def pengajuan_bantuan_beasiswa_params
    params.permit(
      :nama , 
      :no_telepon,
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

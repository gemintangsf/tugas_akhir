class V1::Pengajuan::PengajuanBantuanController < ApplicationController
  #mendapatkan durasi pendaftaran
  def getDurasiPengajuanBeasiswa(return_json: true)
    pengajuan_beasiswa_by_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
  
    if not pengajuan_beasiswa_by_admin.present?
      @duration_pengajuan = 0
      @error_message = "Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!"
    end
  
    start_date = pengajuan_beasiswa_by_admin.created_at.to_datetime
    last_day_of_month = Date.new(start_date.year, start_date.month, -1)
  
    if start_date.month != DateTime.now.month or start_date.year != DateTime.now.year
      @duration_pengajuan = 0
      @error_message = "Pengajuan Bantuan Dana Beasiswa sudah ditutup!"
    else
      @duration_pengajuan = last_day_of_month.day - DateTime.now.day + 1
    end
  
  
    if return_json
      if @error_message
        render_error_response(@error_message)
      else
        render_success_response(Constants::RESPONSE_SUCCESS, @duration_pengajuan, Constants::STATUS_OK)
      end
    else
      @duration_pengajuan
    end
  end

  #Untuk membuat pengajuan bantuan dana beasiswa
  def createPengajuanBeasiswa
    getDurasiPengajuanBeasiswa(return_json: false)
    pengajuan_beasiswa_by_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
  
    if !pengajuan_beasiswa_by_admin.present?
      render_error_response("Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!")
    end
  
    if @duration_pengajuan < 1
      render_error_response("Pengajuan Bantuan Dana Beasiswa sudah ditutup!")
    end
  
    is_civitas = CivitasAkademika.where(nomor_induk: params[:no_identitas_pengaju]).first
  
    if !is_civitas.present?
      render_error_response("NIM tidak dapat ditemukan!")
    end
  
    is_pengajuan = Pengajuan::PengajuanBantuan.not.where(status_pengajuan: Enums::StatusPengajuan::DONE)
                                         .where(no_identitas_pengaju: params[:no_identitas_pengaju])
                                         .where(jenis: "Beasiswa").first
  
    if is_pengajuan.present?
      return render_error_response("Pengajuan Bantuan Dana Beasiswa sudah dilakukan!")
    end
  
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
  
    if beasiswa.save && pengajuan_beasiswa.save && bank.save
      render_success_response({ pengajuan_beasiswa: pengajuan_beasiswa, beasiswa: beasiswa, bank: bank }, "Success", Constants::STATUS_CREATED)
    else
      render_error_response({ pengajuan_beasiswa: pengajuan_beasiswa.errors.full_messages, beasiswa: beasiswa.errors.full_messages, bank: bank.errors.full_messages })
    end
  end

  #Untuk membuat pengajuan bantuan non dana beasiswa
  def createPengajuanNonBeasiswa
    is_civitas_pengaju = CivitasAkademika.where(nomor_induk: params[:no_identitas_pengaju]).first
    is_civitas_penerima = CivitasAkademika.where(nomor_induk: params[:no_identitas_penerima]).first
  
    if !is_civitas_pengaju.present? && !is_civitas_penerima.present?
      return render_error_response("NIM/NIP Penanggung Jawab dan Penerima tidak dapat ditemukan!")
    elsif !is_civitas_pengaju.present?
      return render_error_response("NIM/NIP Penanggung Jawab tidak dapat ditemukan!")
    elsif !is_civitas_penerima.present?
      return render_error_response("NIM/NIP Penerima tidak dapat ditemukan!")
    elsif is_civitas_pengaju == is_civitas_penerima
      return render_error_response("Penanggung Jawab harus berbeda!")
    end
  
    non_beasiswa = Pengajuan::NonBeasiswa.new(non_beasiswa_params)
    non_beasiswa.assign_attributes(nama_penerima: is_civitas_penerima.nama)
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.new(pengajuan_bantuan_params)
    bank = Bank.new(bank_params)
    waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
  
    if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
      return render_error_response("Tanggal harus lebih dari hari sekarang!")
    end
  
    pengajuan_bantuan.assign_attributes({ 
      nama: is_civitas_pengaju.nama,
      bank: bank,
      jenis: "NonBeasiswa",
      non_beasiswa: non_beasiswa,
      waktu_galang_dana: waktu_galang_dana,                                    
      status_pengajuan: Enums::StatusPengajuan::NEW,
      status_penyaluran: Enums::StatusPenyaluran::NULL             
    })
  
    if non_beasiswa.save && pengajuan_bantuan.save && bank.save
      render_success_response(Constants::RESPONSE_SUCCESS, { pengajuan_bantuan: pengajuan_bantuan, non_beasiswa: non_beasiswa, bank: bank },Constants::STATUS_CREATED)
    else
      render_error_response({ pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, non_beasiswa: non_beasiswa.errors.full_messages, bank: bank.errors.full_messages })
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
    if params[:id].blank?
      return render_error_response("id tidak boleh kosong!")
    end
  
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: "Beasiswa").where(id: params[:id]).first
  
    if !pengajuan_bantuan.present?
      return render_error_response("Pengajuan Bantuan tidak dapat ditemukan!")
    end
  
    beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first

    if beasiswa.penilaian_esai.present?
      return render_error_response("Penilaian Esai sudah dilakukan!")
    end
  
    if params[:penilaian_esai].blank?
      return render_error_response("Penilaian Esai tidak boleh kosong!")
    end
  
    valid_penilaian_values = %w[Kurang Cukup Baik SangatBaik]
    unless valid_penilaian_values.include?(params[:penilaian_esai])
      return render_error_response("Penilaian Esai #{params[:penilaian_esai]} tidak ada!, hanya ada Kurang/Cukup/Baik/SangatBaik")
    end
  
    penilaian_esai = case params[:penilaian_esai]
                     when "Kurang" then Enums::PenilaianEsai::LESS
                     when "Cukup" then Enums::PenilaianEsai::ENOUGH
                     when "Baik" then Enums::PenilaianEsai::GOOD
                     when "SangatBaik" then Enums::PenilaianEsai::VERYGOOD
                     end
  
    beasiswa.assign_attributes(penilaian_esai: penilaian_esai)
  
    if beasiswa.save
      render_success_response(Constants::RESPONSE_SUCCESS, { pengajuan_bantuan: pengajuan_bantuan, beasiswa: beasiswa }, Constants::STATUS_CREATED)
    else
      render_error_response(pengajuan_bantuan.errors.full_messages)
    end
  end

  #Untuk melakukan approval pengajuan beasiswa
  def selectNewPengajuan
    getDurasiPengajuanBeasiswa(return_json: false)
    if params[:id].blank?
      return render_error_response("id tidak boleh kosong!")
    end
  
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(id: params[:id]).first
  
    if !pengajuan_bantuan.present?
      return render_error_response("Data Pengajuan Baru tidak ditemukan!")
    end
    penggalangan_dana = Penggalangan::PenggalanganDana.where(:pengajuan_bantuan_id => pengajuan_bantuan.id).first
    if params[:is_approve].blank?
      return render_error_response("is_approve tidak boleh kosong!")
    end
  
    unless %w[true false].include?(params[:is_approve])
      return render_error_response("is_approve hanya dapat true atau false!")
    end

    status_pengajuan = params[:is_approve] == "true" ? Enums::StatusPengajuan::APPROVED : Enums::StatusPengajuan::REJECTED
    status_penyaluran = params[:is_approve] == "true" ? Enums::StatusPenyaluran::NEW : Enums::StatusPenyaluran::NULL
  
    if pengajuan_bantuan.jenis == "Beasiswa"
      pengajuan_admin = Pengajuan::PengajuanBantuan.pengajuan_baru_admin.first
      penggalangan_dana_beasiswa = Penggalangan::PenggalanganDana.where(pengajuan_bantuan_id: pengajuan_admin).first
      beasiswa = Pengajuan::Beasiswa.where(id: pengajuan_bantuan.beasiswa_id).first
  
      if beasiswa.penilaian_esai.nil?
        return render_error_response("Penilaian Esai tidak boleh kosong!")
      end

      if @duration_pengajuan > 1
        return render_error_response("Pendaftaran Beasiswa masih dibuka!")
      end
      beasiswa.assign_attributes(nominal_penyaluran: Constants::NOMINAL_PENYALURAN)
  
      pengajuan_bantuan.assign_attributes({ 
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran
      })
  
      array_of_pengajuan_bantuan_id = penggalangan_dana_beasiswa.pengajuan_bantuan_id.kind_of?(Array) ? penggalangan_dana_beasiswa.pengajuan_bantuan_id : [penggalangan_dana_beasiswa.pengajuan_bantuan_id]
      array_of_pengajuan_bantuan_id << pengajuan_bantuan.id
      penggalangan_dana_beasiswa.assign_attributes({ pengajuan_bantuan_id: array_of_pengajuan_bantuan_id })
  
      if penggalangan_dana_beasiswa.save!(:validate => false) && pengajuan_bantuan.save && beasiswa.save
        render_success_response(Constants::RESPONSE_SUCCESS, { pengajuan_bantuan: pengajuan_bantuan, beasiswa: beasiswa }, Constants::STATUS_OK)
      else
        render_error_response({ penggalangan_dana: penggalangan_dana.errors.full_messages, pengajuan_bantuan: pengajuan_bantuan.errors.full_messages, beasiswa: beasiswa.errors.full_messages })
      end
    else  
      pengajuan_bantuan.assign_attributes({ 
        status_pengajuan: status_pengajuan,
        status_penyaluran: status_penyaluran
      })
  
      penggalangan_dana = Penggalangan::PenggalanganDana.new(
        total_pengajuan: "1",
        total_nominal_terkumpul: 0,
        pengajuan_bantuan: pengajuan_non_beasiswa
      )
  
      if pengajuan_bantuan.save && penggalangan_dana.save
        render_success_response(Constants::RESPONSE_SUCCESS, { penggalangan_dana: penggalangan_dana, pengajuan_bantuan: pengajuan_bantuan }, Constants::STATUS_OK)
      else
        render_error_response(pengajuan_non_beasiswa.errors.full_messages)
      end
    end
  end

  def getPengajuanBantuan
    jenis = params[:jenis]
    is_pengajuan = params[:is_pengajuan] == "true"
  
    valid_jenis = ["Beasiswa", "NonBeasiswa"]
    
    if jenis.blank?
      return render_error_response("Jenis tidak boleh kosong!")
    end
    
    unless valid_jenis.include?(jenis)
      return render_error_response("Jenis #{jenis} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa")
    end
    
    pengajuan_bantuan = is_pengajuan ? Pengajuan::PengajuanBantuan.pengajuan_baru : Pengajuan::PengajuanBantuan.pengajuan_approved
    pengajuan_bantuan = pengajuan_bantuan.where(jenis: jenis)
    
    if pengajuan_bantuan.empty?
      return render_error_response(is_pengajuan ? "Tidak ada data Pengajuan Baru Bantuan Dana #{jenis}!" : "Tidak ada data Penerima Bantuan Dana #{jenis}!")
    end
    
    data_array = []
    
    pengajuan_bantuan.each do |data_pengajuan|
      if jenis == "Beasiswa"
        beasiswa = Pengajuan::Beasiswa.where(id: data_pengajuan.beasiswa_id).first
        penerima_data = data_pengajuan.attributes.merge({
          beasiswa_id: beasiswa,
          bank_id: Bank.where(id: data_pengajuan.bank_id).first
        })
      else
        non_beasiswa = Pengajuan::NonBeasiswa.where(id: data_pengajuan.non_beasiswa_id).first
        penerima_data = data_pengajuan.attributes.merge({
          non_beasiswa_id: non_beasiswa,
          bank_id: Bank.where(id: data_pengajuan.bank_id).first
        })
      end
      data_array << penerima_data
    end
    
    render_success_response(Constants::RESPONSE_SUCCESS, data_array.reverse, Constants::STATUS_OK)
  end

  def getNonBeasiswaByKategori
    kategori = params[:kategori]
    valid_kategoris = ["Medis", "Bencana", "Duka"]
  
    if kategori.blank?
      return render_error_response("Kategori tidak boleh kosong!")
    end
  
    unless valid_kategoris.include?(kategori)
      return render_error_response("Kategori #{kategori} tidak ada!, Kategori hanya Medis/Bencana/Duka")
    end
  
    non_beasiswa = Pengajuan::NonBeasiswa.where(kategori: kategori)
  
    if non_beasiswa.empty?
      return render_error_response("Tidak ada data Pengajuan Bantuan Dana Non Beasiswa berdasarkan kategori #{kategori}!")
    end
  
    pengajuan_bantuan = params[:is_pengajuan] == "true" ? Pengajuan::PengajuanBantuan.pengajuan_baru : Pengajuan::PengajuanBantuan.pengajuan_approved
    pengajuan_bantuan = pengajuan_bantuan.where(:non_beasiswa_id.in => non_beasiswa.pluck(:id))
  
    if pengajuan_bantuan.empty?
      return render_error_response(params[:is_pengajuan] == "true" ? "Tidak ada data pengajuan baru Non Beasiswa berdasarkan kategori #{kategori}!" : "Tidak ada data Penerima Bantuan Dana Non Beasiswa berdasarkan kategori #{kategori}!")
    end
  
    non_beasiswa_new = Pengajuan::NonBeasiswa.where(:id.in => pengajuan_bantuan.pluck(:non_beasiswa_id))
    data_pengajuan_non_beasiswa = []
  
    pengajuan_bantuan.each_with_index do |data_pengajuan, index_pengajuan_bantuan|
      non_beasiswa_new.each_with_index do |data_non_beasiswa, index_non_beasiswa|
        if index_pengajuan_bantuan == index_non_beasiswa
          bank = Bank.where(id: data_pengajuan.bank_id).first
          data_pengajuan_non_beasiswa << data_pengajuan.attributes.merge({
            non_beasiswa_id: data_non_beasiswa,
            bank_id: bank
          })
        end
      end
    end
  
    new_data_pengajuan = data_pengajuan_non_beasiswa.reverse
  
    render_success_response(Constants::RESPONSE_SUCCESS, new_data_pengajuan, Constants::STATUS_OK)
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
    valid_jenis = ["Beasiswa", "NonBeasiswa"]
    jenis = params[:jenis]
  
    unless valid_jenis.include?(jenis)
      return render_error_response("Jenis #{jenis} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa")
    end
  
    pengajuan_bantuan = Pengajuan::PengajuanBantuan.pengajuan_baru.where(jenis: jenis)
    total_calon_pengajuan = pengajuan_bantuan.length
  
    render_success_response(Constants::RESPONSE_SUCCESS, total_calon_pengajuan, Constants::STATUS_OK)
  end

  def getTotalPenerimaBantuan
    pengajuan_bantuan_approved = Pengajuan::PengajuanBantuan.pengajuan_approved
    total_pengajuan_approved = pengajuan_bantuan_approved.length
  
    pengajuan_bantuan_done = Pengajuan::PengajuanBantuan.done
    total_pengajuan_done = pengajuan_bantuan_done.length
  
    total_pengajuan = total_pengajuan_approved + total_pengajuan_done
  
    render_success_response(
      Constants::RESPONSE_SUCCESS,
      {
        penerima_bantuan_admin: total_pengajuan_approved,
        penerima_bantuan_penggalangan_dana: total_pengajuan
      },
      Constants::STATUS_OK
    )
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

  def calculate_duration_pengajuan_beasiswa

  end
end

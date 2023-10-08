class V1::Pengajuan::PengajuanBantuanController < ApplicationController
  #mendapatkan durasi pendaftaran
  def getDurasiPengajuanBeasiswa(return_json: true)
    penggalangan_dana_beasiswa_on_going = PenggalanganDanaBeasiswa.where(status: 0).first
  
    if not penggalangan_dana_beasiswa_on_going.present?
      @duration_pengajuan = 0
      @error_message = "Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!"
    else
      start_date = penggalangan_dana_beasiswa_on_going.waktu_dimulai
      last_day_of_month = Date.new(start_date.year, start_date.month, -1)
      if start_date.month != DateTime.now.month or start_date.year != DateTime.now.year
        @duration_pengajuan = -1
        @error_message = "Pengajuan Bantuan Dana Beasiswa sudah ditutup!"
      else
        @duration_pengajuan = last_day_of_month.day - DateTime.now.day + 1
      end
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
  
    if @duration_pengajuan == 0
      return render_error_response("Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!")
    elsif @duration_pengajuan == -1
      return render_error_response("Pengajuan Bantuan Dana Beasiswa sudah ditutup!")
    end
  
    penggalangan_dana_beasiswa_on_going = PenggalanganDanaBeasiswa.on_going.first
  
    if !penggalangan_dana_beasiswa_on_going.present?
      return render_error_response("Pendaftaran Pengajuan Bantuan Dana Beasiswa belum dibuka!")
    end
  
    is_civitas = CivitasAkademika.where(nomor_induk: params[:nim]).first
  
    if !is_civitas.present?
      return render_error_response("NIM tidak dapat ditemukan!")
    end

    list_bantuan_dana_beasiswa_on_going = BantuanDanaBeasiswa.pengajuan_on_going.where(penggalangan_dana_beasiswa_id: penggalangan_dana_beasiswa_on_going.penggalangan_dana_beasiswa_id)
    if list_bantuan_dana_beasiswa_on_going.present?
      is_pengajuan = list_bantuan_dana_beasiswa_on_going.pengajuan_on_going.where(mahasiswa_id: params[:nim]).first
    end
  
    if is_pengajuan.present?
      return render_error_response("Pengajuan Bantuan Dana Beasiswa sudah dilakukan")
    end

    bantuan_dana_beasiswa = BantuanDanaBeasiswa.new(bantuan_dana_beasiswa_params)
    mahasiswa_registered = Mahasiswa.where(nim: params[:nim]).first
    if mahasiswa_registered.present?
      mahasiswa = mahasiswa_registered
    else
      mahasiswa = Mahasiswa.new(mahasiswa_params)
      mahasiswa.assign_attributes(nama: is_civitas.nama)
    end

    rekening_bank_owned = RekeningBank.where(nomor_rekening: params[:nomor_rekening]).first
    rekening_bank_registered = RekeningBank.where(mahasiswa_id: params[:nim]).first
    if rekening_bank_registered.present?
      rekening_bank = rekening_bank_registered
    elsif rekening_bank_owned.present?
      return render_error_response("Nomor Rekening sudah terdaftar!")
    else
      rekening_bank = RekeningBank.new(rekening_bank_params)
      rekening_bank.assign_attributes({
        mahasiswa_id: mahasiswa
      })
    end
    bantuan_dana_beasiswa.assign_attributes({ 
      bantuan_dana_beasiswa_id: randomize_bantuan_dana_beasiswa_id(),
      mahasiswa: mahasiswa,
      penggalangan_dana_beasiswa: penggalangan_dana_beasiswa_on_going,
      status_pengajuan: Enums::StatusPengajuan::NEW,
      status_penyaluran: Enums::StatusPenyaluran::NULL
    })
  
    rekening_bank.assign_attributes({
      mahasiswa: mahasiswa
    })
  
    if bantuan_dana_beasiswa.save && mahasiswa.save && rekening_bank.save
      render_success_response(Constants::RESPONSE_SUCCESS, { mahasiswa: mahasiswa, bantuan_dana_beasiswa: bantuan_dana_beasiswa, rekening_bank: rekening_bank }, Constants::STATUS_CREATED)
    else
      render_error_response({ mahasiswa: mahasiswa.errors.full_messages, bantuan_dana_beasiswa: bantuan_dana_beasiswa.errors.full_messages, rekening_bank: rekening_bank.errors.full_messages })
    end
  end
  
  

  #Untuk membuat pengajuan bantuan non dana beasiswa
  def createPengajuanNonBeasiswa
    is_civitas_pengaju = CivitasAkademika.where(nomor_induk: params[:nomor_induk_penanggung_jawab]).first
    is_civitas_penerima = CivitasAkademika.where(nomor_induk: params[:nomor_induk_penerima]).first
  
    if !is_civitas_pengaju.present? && !is_civitas_penerima.present?
      return render_error_response("NIM/NIP Penanggung Jawab dan Penerima tidak dapat ditemukan!")
    elsif !is_civitas_pengaju.present?
      return render_error_response("NIM/NIP Penanggung Jawab tidak dapat ditemukan!")
    elsif !is_civitas_penerima.present?
      return render_error_response("NIM/NIP Penerima tidak dapat ditemukan!")
    elsif is_civitas_pengaju == is_civitas_penerima
      return render_error_response("Penanggung Jawab harus berbeda!")
    end

    penerima_non_beasiswa_registered = PenerimaNonBeasiswa.where(nomor_induk: params[:nomor_induk_penerima]).first
    penanggung_jawab_non_beasiswa_registered = PenanggungJawabNonBeasiswa.where(nomor_induk: params[:nomor_induk_penanggung_jawab]).first
    
    if !penerima_non_beasiswa_registered.present?
      penerima_non_beasiswa = PenerimaNonBeasiswa.new(
        nama: is_civitas_penerima.nama,
        nomor_induk: params[:nomor_induk_penerima],
        nomor_telepon: params[:nomor_telepon_penerima]
      )
    else
      penerima_non_beasiswa = penerima_non_beasiswa_registered
    end

    if !penanggung_jawab_non_beasiswa_registered.present?
      penanggung_jawab_non_beasiswa = PenanggungJawabNonBeasiswa.new(
        nama: is_civitas_pengaju.nama,
        nomor_induk: params[:nomor_induk_penanggung_jawab],
        nomor_telepon: params[:nomor_induk_penanggung_jawab]
      )
    else
      penanggung_jawab_non_beasiswa = penanggung_jawab_non_beasiswa_registered
    end

    penanggungjawabnonbeasiswa_has_penerimanonbeasiswa_registered = PenanggungJawabNonBeasiswaHasPenerimaNonBeasiswa.where(penanggung_jawab_non_beasiswa_id: params[:nomor_induk_penanggung_jawab]).first
    penerimanonbeasiswa_has_penanggungjawabnonbeasiswa_registered = PenanggungJawabNonBeasiswaHasPenerimaNonBeasiswa.where(penerima_non_beasiswa_id: params[:nomor_induk_penerima]).first
    if !penanggungjawabnonbeasiswa_has_penerimanonbeasiswa_registered.present? and penerimanonbeasiswa_has_penanggungjawabnonbeasiswa_registered.present?
      if penerimanonbeasiswa_has_penanggungjawabnonbeasiswa_registered.penanggung_jawab_non_beasiswa_id != params[:nomor_induk_penanggung_jawab]
        penerima_non_beasiswa.penanggung_jawab_non_beasiswa << penanggung_jawab_non_beasiswa
      end
    elsif !penerimanonbeasiswa_has_penanggungjawabnonbeasiswa_registered.present? and penanggungjawabnonbeasiswa_has_penerimanonbeasiswa_registered.present?
      if penanggungjawabnonbeasiswa_has_penerimanonbeasiswa_registered.penerima_non_beasiswa_id != params[:nomor_induk_penerima]
        penanggung_jawab_non_beasiswa.penerima_non_beasiswa << penerima_non_beasiswa
      end
    else
      penanggung_jawab_non_beasiswa.penerima_non_beasiswa << penerima_non_beasiswa
    end

    rekening_bank_owned = RekeningBank.where(nomor_rekening: params[:nomor_rekening]).first
    rekening_bank_registered = RekeningBank.where(penerima_non_beasiswa_id: params[:nomor_induk_penerima]).first
    if rekening_bank_registered.present?
      rekening_bank = rekening_bank_registered
    elsif rekening_bank_owned.present?
      return render_error_response("Nomor Rekening sudah terdaftar!")
    else
      rekening_bank = RekeningBank.new(rekening_bank_params)
      rekening_bank.assign_attributes({
        penerima_non_beasiswa: penerima_non_beasiswa
      })
    end

    
    waktu_galang_dana = DateTime.parse(params[:waktu_galang_dana])
  
    if (waktu_galang_dana - DateTime.now).to_i + 1 < 1
      return render_error_response("Tanggal harus lebih dari hari sekarang!")
    end
  
    bantuan_dana_non_beasiswa = BantuanDanaNonBeasiswa.new(bantuan_dana_non_beasiswa_params)

    bantuan_dana_non_beasiswa.assign_attributes({
      bantuan_dana_non_beasiswa_id: randomize_bantuan_dana_non_beasiswa_id(),
      waktu_galang_dana: waktu_galang_dana,
      penanggung_jawab_non_beasiswa: penanggung_jawab_non_beasiswa,
      status_pengajuan: Enums::StatusPengajuan::NEW,
      status_penyaluran: Enums::StatusPenyaluran::NULL
    })
  
    if penerima_non_beasiswa.save && penanggung_jawab_non_beasiswa.save && rekening_bank.save && bantuan_dana_non_beasiswa.save
      render_success_response(Constants::RESPONSE_SUCCESS,{ penerima_non_beasiswa: penerima_non_beasiswa, penanggung_jawab_non_beasiswa: penanggung_jawab_non_beasiswa, rekening_bank: rekening_bank, bantuan_dana_non_beasiswa: bantuan_dana_non_beasiswa}, Constants::STATUS_CREATED)
    else
      render_error_response({ 
        penerima_non_beasiswa: penerima_non_beasiswa.errors.full_messages, 
        penanggung_jawab_non_beasiswa: penanggung_jawab_non_beasiswa.errors.full_messages, 
        rekening_bank: rekening_bank.errors.full_messages,
        bantuan_dana_non_beasiswa: bantuan_dana_non_beasiswa.errors.full_messages
        })
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
  
    bantuan_dana_beasiswa = BantuanDanaBeasiswa.where(bantuan_dana_beasiswa_id: params[:id]).first
  
    if !bantuan_dana_beasiswa.present?
      return render_error_response("Bantuan Dana Beasiswa tidak dapat ditemukan!")
    end
  
    if bantuan_dana_beasiswa.penilaian_esai.present?
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
    bantuan_dana_beasiswa.assign_attributes({penilaian_esai: penilaian_esai})

    if bantuan_dana_beasiswa.save
      render_success_response(Constants::RESPONSE_SUCCESS, { bantuan_dana_beasiswa: bantuan_dana_beasiswa }, Constants::STATUS_CREATED)
    else
      render_error_response(bantuan_dana_beasiswa.errors.full_messages)
    end
  end

  def approvalPengajuanBeasiswa
    getDurasiPengajuanBeasiswa(return_json: false)
    if @duration_pengajuan > 1
      return render_error_response("Pendaftaran Beasiswa masih dibuka!")
    end

    if params[:id].blank?
      return render_error_response("id tidak boleh kosong!")
    end

    bantuan_dana_beasiswa = BantuanDanaBeasiswa.where(bantuan_dana_beasiswa_id: params[:id]).first

    if !bantuan_dana_beasiswa.present?
      return render_error_response("Pengajuan Bantuan Dana Beasiswa tidak dapat ditemukan!")
    end

    if !bantuan_dana_beasiswa.penilaian_esai.present?
      return render_error_response("Penilaian Esai tidak boleh kosong!")
    end

    if params[:is_approve].blank?
      return render_error_response("is_approve tidak boleh kosong!")
    end
    
    unless %w[true false].include?(params[:is_approve])
      return render_error_response("is_approve hanya dapat true atau false!")
    end

    status_pengajuan = params[:is_approve] == "true" ? Enums::StatusPengajuan::APPROVED : Enums::StatusPengajuan::REJECTED
    status_penyaluran = params[:is_approve] == "true" ? Enums::StatusPenyaluran::NEW : Enums::StatusPenyaluran::NULL

    bantuan_dana_beasiswa.assign_attributes({
      status_pengajuan: status_pengajuan,
      status_penyaluran: [status_penyaluran],
      nominal_penyaluran: [Constants::NOMINAL_PENYALURAN],
    })

    if bantuan_dana_beasiswa.save
      render_success_response(Constants::RESPONSE_SUCCESS, bantuan_dana_beasiswa, Constants::STATUS_OK)
    else
      render_error_response(bantuan_dana_beasiswa: bantuan_dana_beasiswa.errors.full_messages)
    end
  end

  def approvalPengajuanNonBeasiswa
    if params[:id].blank?
      return render_error_response("id tidak boleh kosong!")
    end

    bantuan_dana_non_beasiswa = BantuanDanaNonBeasiswa.where(bantuan_dana_non_beasiswa_id: params[:id]).first

    if !bantuan_dana_non_beasiswa.present?
      return render_error_response("Pengajuan Bantuan Dana Non Beasiswa tidak dapat ditemukan!")
    end

    if params[:is_approve].blank?
      return render_error_response("is_approve tidak boleh kosong!")
    end
    
    unless %w[true false].include?(params[:is_approve])
      return render_error_response("is_approve hanya dapat true atau false!")
    end

    is_approval = (bantuan_dana_non_beasiswa.waktu_galang_dana - DateTime.now).to_i

    if is_approval < 1
      return render_error_response("waktu berakhir penggalangan dana sudah lebih dari tanggal approval!")
    end

    status_pengajuan = params[:is_approve] == "true" ? Enums::StatusPengajuan::APPROVED : Enums::StatusPengajuan::REJECTED
    status_penyaluran = params[:is_approve] == "true" ? Enums::StatusPenyaluran::NEW : Enums::StatusPenyaluran::NULL

    bantuan_dana_non_beasiswa.assign_attributes({
      status_pengajuan: status_pengajuan,
      status_penyaluran: status_penyaluran,
      total_nominal_terkumpul: Constants::NOMINAL_PENGGALANGAN_DANA_BARU
    })

    if bantuan_dana_non_beasiswa.save
      render_success_response(Constants::RESPONSE_SUCCESS, bantuan_dana_non_beasiswa, Constants::STATUS_OK)
    else
      render_error_response(bantuan_dana_beasiswa: bantuan_dana_non_beasiswa.errors.full_messages)
    end
  end

  def getBulanPenyaluran(beasiswa)
    date_pengajuan = beasiswa.updated_at
    array_of_bulan_penyaluran = []
    array_of_bulan_penyaluran << date_pengajuan
    beasiswa.assign_attributes(bulan_penyaluran: array_of_bulan_penyaluran)
    beasiswa.save
  end

  def getPengajuanBeasiswa(status_pengajuan)
    penggalangan_dana_beasiswa_on_going = PenggalanganDanaBeasiswa.on_going.first
    list_bantuan_dana_beasiswa_baru = BantuanDanaBeasiswa.where(status_pengajuan: status_pengajuan).where(penggalangan_dana_beasiswa_id: penggalangan_dana_beasiswa_on_going.penggalangan_dana_beasiswa_id)
    if !list_bantuan_dana_beasiswa_baru.present?
      error_message = "Tidak ada data Pengajuan Bantuan Dana Beasiswa!"
    else
      array_of_pengajuan_beasiswa_baru = []
      if list_bantuan_dana_beasiswa_baru.length > 1
        list_bantuan_dana_beasiswa_baru.each do |data|
          array_of_pengajuan_beasiswa_baru << data.attributes.merge({
            mahasiswa_id: Mahasiswa.where(nim: data.mahasiswa_id).first,
          })
        end
      else
        bantuan_dana_beasiswa = list_bantuan_dana_beasiswa_baru.first
        array_of_pengajuan_beasiswa_baru << bantuan_dana_beasiswa.attributes.merge({
          mahasiswa_id: Mahasiswa.where(nim: bantuan_dana_beasiswa.mahasiswa_id).first,
        })
      end
    end
    return [error_message, array_of_pengajuan_beasiswa_baru]
  end

  def getPengajuanNonBeasiswa(status_pengajuan)
    list_bantuan_dana_non_beasiswa = BantuanDanaNonBeasiswa.where(status_pengajuan: status_pengajuan)
    if !list_bantuan_dana_non_beasiswa.present?
      error_message = "Tidak ada data Pengajuan Bantuan Dana Non Beasiswa!"
    else
      array_of_pengajuan_non_beasiswa_baru = []
      if list_bantuan_dana_non_beasiswa.length > 0
        list_bantuan_dana_non_beasiswa.each do |data|
          penanggung_jawab_penerima_non_beasiswa = PenanggungJawabNonBeasiswaHasPenerimaNonBeasiswa.where(penanggung_jawab_non_beasiswa_id: data.penanggung_jawab_non_beasiswa_id).first
          array_of_pengajuan_non_beasiswa_baru << data.attributes.merge({
            penanggung_jawab_non_beasiswa_id: PenanggungJawabNonBeasiswa.where(nomor_induk: data.penanggung_jawab_non_beasiswa_id).first,
            penerima_non_beasiswa: PenerimaNonBeasiswa.where(nomor_induk: penanggung_jawab_penerima_non_beasiswa.penerima_non_beasiswa_id).first
          })
        end
      else
        bantuan_dana_non_beasiswa = list_bantuan_dana_non_beasiswa.first
        penanggung_jawab_penerima_non_beasiswa = PenanggungJawabNonBeasiswaHasPenerimaNonBeasiswa.where(penanggung_jawab_non_beasiswa_id: bantuan_dana_non_beasiswa.penanggung_jawab_non_beasiswa_id).first
        array_of_pengajuan_non_beasiswa_baru << bantuan_dana_non_beasiswa.attributes.merge({
          penanggung_jawab_non_beasiswa_id: PenanggungJawabNonBeasiswa.where(nomor_induk: bantuan_dana_non_beasiswa.penanggung_jawab_non_beasiswa_id).first,
          penerima_non_beasiswa: PenerimaNonBeasiswa.where(nomor_induk: penanggung_jawab_penerima_non_beasiswa.penerima_non_beasiswa_id).first
        })
      end
    end
    return [error_message, array_of_pengajuan_non_beasiswa_baru]
  end

  def getPengajuanBantuan
    valid_jenis = ["Beasiswa", "NonBeasiswa"]
    valid_is_pengajuan = ["true", "false"]
    
    if params[:jenis].blank?
      return render_error_response("Jenis tidak boleh kosong!")
    end
    
    unless valid_jenis.include?(params[:jenis])
      return render_error_response("Jenis #{params[:jenis]} tidak ada!, Jenis hanya Beasiswa atau NonBeasiswa")
    end

    if params[:is_pengajuan].blank?
      return render_error_response("is_pengajuan tidak boleh kosong!")
    end
    
    unless valid_is_pengajuan.include?(params[:is_pengajuan])
      return render_error_response("Is_pengajuan hanya true atau false")
    end

    if params[:is_pengajuan] == "true"
      status_pengajuan = Enums::StatusPengajuan::NEW
    else
      status_pengajuan = Enums::StatusPengajuan::APPROVED
    end
    error_message_beasiswa, array_of_pengajuan_beasiswa_baru = getPengajuanBeasiswa(status_pengajuan)
    error_message_non_beasiswa, array_of_pengajuan_non_beasiswa_baru = getPengajuanNonBeasiswa(status_pengajuan)

    if params[:jenis] == "Beasiswa" and error_message_beasiswa != nil
      return render_error_response(error_message_beasiswa)
    end
    if params[:jenis] == "NonBeasiswa" and error_message_non_beasiswa != nil
      return render_error_response(error_message_non_beasiswa)
    end
    
    if params[:jenis] == "Beasiswa"
      render_success_response(Constants::RESPONSE_SUCCESS, array_of_pengajuan_beasiswa_baru, Constants::STATUS_OK)
    else
      render_success_response(Constants::RESPONSE_SUCCESS, array_of_pengajuan_non_beasiswa_baru, Constants::STATUS_OK)
    end
  end

  def getNonBeasiswaByKategori
    kategori = params[:kategori]
    valid_kategoris = ["Medis", "Bencana", "Duka"]
    valid_is_pengajuan = ["true", "false"]
  
    if kategori.blank?
      return render_error_response("Kategori tidak boleh kosong!")
    end
  
    unless valid_kategoris.include?(kategori)
      return render_error_response("Kategori #{kategori} tidak ada!, Kategori hanya Medis/Bencana/Duka")
    end

    if params[:is_pengajuan].blank?
      return render_error_response("is_pengajuan tidak boleh kosong!")
    end
  
    unless valid_is_pengajuan.include?(params[:is_pengajuan])
      return render_error_response("is_pengajuan hanya true atau false")
    end

    if params[:is_pengajuan] == "true"
      status_pengajuan = Enums::StatusPengajuan::NEW
    else
      status_pengajuan = Enums::StatusPengajuan::APPROVED
    end
  
    error_message, array_of_pengajuan_non_beasiswa_baru = getPengajuanNonBeasiswa(status_pengajuan)
    
    if error_message != nil
      return render_error_response(error_message)
    end

    filter_by_kategori = array_of_pengajuan_non_beasiswa_baru.select { |item| item['kategori'] == params[:kategori] }
    render_success_response(Constants::RESPONSE_SUCCESS, filter_by_kategori, Constants::STATUS_OK)
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

    bantuan_dana_non_beasiswa = BantuanDanaNonBeasiswa.pengajuan_baru
    render_success_response(Constants::RESPONSE_SUCCESS, bantuan_dana_non_beasiswa.length, Constants::STATUS_OK)
  end

  def getTotalPenerimaBantuan
    bantuan_dana_beasiswa_approved = BantuanDanaBeasiswa.pengajuan_approved
    bantuan_dana_non_beasiswa_approved = BantuanDanaNonBeasiswa.pengajuan_approved
    total_penerima_bantuan_on_going = bantuan_dana_beasiswa_approved.length + bantuan_dana_non_beasiswa_approved.length
    bantuan_dana_beasiswa_done = BantuanDanaBeasiswa.pengajuan_done
    bantuan_dana_non_beasiswa_done = BantuanDanaNonBeasiswa.pengajuan_done
    total_penerima_bantuan_done = bantuan_dana_beasiswa_done.length + bantuan_dana_non_beasiswa_done.length
  
    total_all_penerima_bantuan = total_penerima_bantuan_on_going+ total_penerima_bantuan_done
    render_success_response(
      Constants::RESPONSE_SUCCESS,
      {
        penerima_bantuan_admin: total_penerima_bantuan_on_going,
        penerima_bantuan_penggalangan_dana: total_all_penerima_bantuan
      },
      Constants::STATUS_OK
    )
  end

  private
  #form pengaju
  def rekening_bank_params
    params.permit(:nama_bank, :nomor_rekening, :nama_pemilik_rekening)
  end

  def mahasiswa_params
    params.permit(
      :nim, 
      :nama,
      :nomor_telepon
    )
  end
  #form beasiswa
  def bantuan_dana_beasiswa_params
    params.permit(
      :alasan_butuh_bantuan,
      :golongan_ukt, 
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
  def bantuan_dana_non_beasiswa_params
    params.permit(
      :judul_galang_dana, 
      :waktu_galang_dana, 
      :deskripsi_galang_dana, 
      :dana_yang_dibutuhkan,
      :bukti_butuh_bantuan,
      :kategori,
    )
  end

  def randomize_bantuan_dana_beasiswa_id
    begin
      return bantuan_dana_beasiswa_id = SecureRandom.random_number(1_000_000)
    end while BantuanDanaBeasiswa.where(bantuan_dana_beasiswa_id: bantuan_dana_beasiswa_id).exists?
  end

  def randomize_bantuan_dana_non_beasiswa_id
    begin
      return bantuan_dana_beasiswa_id = SecureRandom.random_number(1_000_000)
    end while BantuanDanaNonBeasiswa.where(bantuan_dana_non_beasiswa_id: bantuan_dana_non_beasiswa_id).exists?
  end
end

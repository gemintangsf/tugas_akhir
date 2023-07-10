require 'swagger_helper'

describe 'Pengajuan Bantuan API' do
  path '/v1/pengajuan/pengajuan_bantuan/createPengajuanBeasiswa' do
    post 'Create Pengajuan Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            nama: {type: :string, example: "Gemintang"},
            no_identitas_pengaju: {type: :string, example: "191524009"},
            no_telepon: {type: :string, example: "082118397901"},
            nomor_rekening: {type: :string, example: "21312214"},
            nama_pemilik_rekening: {type: :string, example: "Gemintang"},
            bank: {type: :string, example: "BSI"},
            deskripsi: {type: :string, example: "membutuhkan bantuan dana untuk kuliah"},
            golongan_ukt: {type: :integer, example: 1},
            kuitansi_pembayaran_ukt: {type: :string, example: "path"},
            gaji_orang_tua: {type: :integer, example: 4000000},
            bukti_slip_gaji_orang_tua: {type: :string, example: "path"},
            esai: {type: :string, example: "path"},
            jumlah_tanggungan_keluarga: {type: :integer, example: 2},
            biaya_transportasi: {type: :string, example: "100000"},
            biaya_konsumsi: {type: :string, example: "1000000"},
            biaya_internet: {type: :string, example: "1000000"},
            biaya_kos: {type: :string, example: "1000000"},
            total_pengeluaran_keluarga: {type: :integer, example: 5000000},
        },
        required: []
      }
      response '201', 'Created' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Data tidak boleh kosong!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Tidak memiliki akses!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end
  path '/v1/pengajuan/pengajuan_bantuan/createPengajuanNonBeasiswa' do
    post 'Create Pengajuan Non Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            nama: {type: :string, example: "Gemintang"},
            no_identitas_pengaju: {type: :string, example: "191524009"},
            no_telepon: {type: :string, example: "082118397901"},
            nomor_rekening: {type: :string, example: "21312214"},
            nama_pemilik_rekening: {type: :string, example: "Gemintang"},
            bank: {type: :string, example: "BSI"},
            judul_galang_dana: {type: :string, example: "Galang Dana untuk Pengobatan"},
            waktu_galang_dana: {type: :string, example: "30-06-2023"},
            deskripsi: {type: :string, example: "Membutuhkan biaya untuk pengobatan"},
            dana_yang_dibutuhkan: {type: :integer, example: 1000000},
            nama_penerima: {type: :string, example: "Tatang"},
            no_identitas_penerima: {type: :string, example: "191524024"},
            no_telepon_penerima: {type: :string, example: "082118397901"},
            bukti_butuh_bantuan: {type: :string, example: "path"},
            kategori: {type: :string, example: "Medis"},
        },
        required: []
      }
      response '201', 'Created' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Data tidak boleh kosong!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Tidak memiliki akses!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/getPengajuan' do
    post 'Get Pengajuan Bantuan Dana' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            jenis: {type: :string, example: "Beasiswa"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/getPengajuanNonBeasiswaByKategori' do
    post 'Get Pengajuan Non Beasiswa By Kategori' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            kategori: {type: :string, example: "Medis"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/getPenerimaBantuanDana' do
    post 'Get Penerima Bantuan Dana' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            jenis: {type: :string, example: "Beasiswa"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end
  
  path '/v1/pengajuan/pengajuan_bantuan/getPenerimaNonBeasiswaByKategori' do
    post 'Get Penerima Bantuan Dana' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            kategori: {type: :string, example: "Medis"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/createPenilaianEsai' do
    post 'Create Penilaian Esai Pengajuan Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          id: {type: :string, example: "638235b0e21fac0354b16976"},
          penilaian_esai: {type: :string, example: "Baik"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/selectPengajuanBeasiswa' do
    post 'Approval Pengajuan Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          id: {type: :string, example: "638235b0e21fac0354b16976"},
          is_approve: {type: :string, example: "true"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end
    
  path '/v1/pengajuan/pengajuan_bantuan/selectPengajuanNonBeasiswa' do
    post 'Approval Pengajuan Non Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "638235b0e21fac0354b16976"},
            is_approve: {type: :string, example: "true"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end
  
  path '/v1/pengajuan/pengajuan_bantuan/selectLanjutBeasiswa' do
    post 'Select Penerima Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649d4164e21fac0234f47869"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/getTotalCalonPengajuan' do
    post 'Get Pengajuan Non Beasiswa By Kategori' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            jenis: {type: :string, example: "Beasiswa"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Pengajuan Non Beasiswa tidak dapat ditemukan!"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
        properties: {
          response_message: {type: :string, example: "Tidak memiliki akses!"},
          response_code: {type: :integer, example: 401}
        }
        run_test!
      end
    end
  end


  path '/v1/pengajuan/pengajuan_bantuan/getDurasiPengajuanBeasiswa' do
    get 'Get Durasi Pengajuan Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      response '200', 'Success' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Data tidak Ditemukan"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Tidak memiliki akses!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end

  path '/v1/pengajuan/pengajuan_bantuan/getLanjutBeasiswa' do
    get 'Get Lanjut Penerima Bantuan Dana Beasiswa' do
      tags 'Pengajuan Bantuan'
      consumes 'application/json'
      produces 'application/json'
      response '200', 'Success' do
        schema type: :object
        run_test!
      end
      response '422', 'Unprocessable Entity' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Data tidak Ditemukan"},
                response_code: {type: :integer, example: 422}
              }
        run_test!
      end
      response '401', 'Unauthorized' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Tidak memiliki akses!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end
end

require 'swagger_helper'

describe 'Penggalangan Dana API' do
  path '/v1/penggalangan/penggalangan_dana/createPenggalanganDanaBeasiswa' do
    post 'Create Penggalangan Dana Beasiswa' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64997232e21fac364c2d0d51"},
            judul_galang_dana: {type: :string, example: "Penggalangan Dana untuk Beasiswa"},
            deskripsi: {type: :string, example: "Penggalangan Dana untuk Beasiswa Mahasiswa JTK"},
            waktu_galang_dana: {type: :string, example: "30-12-2023"},
            total_pengajuan: {type: :integer, example: 6},
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
                response_message: {type: :string, example: "Data yang dimasukan salah!"},
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

  path '/v1/penggalangan/penggalangan_dana/createPenggalanganDanaNonBeasiswa' do
    post 'Create Penggalangan Dana Non Beasiswa' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          nama: {type: :string, example: "Gemintang"},
          no_telepon: {type: :string, example: "082118397901"},
          nomor_rekening: {type: :string, example: "21312214"},
          nama_pemilik_rekening: {type: :string, example: "Gemintang"},
          bank: {type: :string, example: "BSI"},
          judul_galang_dana: {type: :string, example: "Galang Dana untuk Pengobatan"},
          waktu_galang_dana: {type: :string, example: "30-06-2023"},
          deskripsi: {type: :string, example: "Membutuhkan biaya untuk pengobatan"},
          dana_yang_dibutuhkan: {type: :integer, example: 1000000},
          nama_penerima: {type: :string, example: "Tatang"},
          no_telepon_penerima: {type: :string, example: "082118397901"},
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
                response_message: {type: :string, example: "Data yang dimasukan salah!"},
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

  path '/v1/penggalangan/penggalangan_dana/getPenggalanganDanaNonBeasiswaByKategori' do
    post 'Get Penggalangan Dana Non Beasiswa By Kategori' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
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
                response_message: {type: :string, example: "Data yang dimasukan salah!"},
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
  path '/v1/penggalangan/penggalangan_dana/selectPenggalanganDana' do
    post 'Select Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649ad853e21fac364c2d0da6"},
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
                response_message: {type: :string, example: "Penggalangan dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getDurasiPenggalanganDana' do
    post 'Get Durasi Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649ad853e21fac364c2d0da6"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getNominalTerkumpulPenggalanganDana' do
    post 'Get Nominal Terkumpul Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649d3a55e21fac0234f47868"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getTotalDonaturInPenggalanganDana' do
    post 'Get Total Donatur Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64a13bfbe21fac2f6492d4fb"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getDataDonaturByPenggalanganDana' do
    post 'Get Data Donatur By Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64b29f45e21fac00f0642fac"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getApprovedDonasiByPenggalanganDana' do
    post 'Get All Approved Donasi by Penggalangan Dana' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649dd899e21fac1f60f56d45"},
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
                response_message: {type: :string, example: "Data tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getAllPenggalanganDana' do
    get 'Get All Penggalangan Dana' do
      tags 'Penggalangan Dana'
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

  path '/v1/penggalangan/penggalangan_dana/getTotalPenggalanganDana' do
    get 'Get Total All Penggalangan Dana' do
      tags 'Penggalangan Dana'
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
  
  path '/v1/penggalangan/penggalangan_dana/getSaldoAwal' do
    post 'Get Saldo Awal in Batch Beasiswa' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64b29f82e21fac00f0642fb1"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getTotalPengeluaran' do
    post 'Get Total Pengeluaran in Batch Beasiswa' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64b29f82e21fac00f0642fb1"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

  path '/v1/penggalangan/penggalangan_dana/getSaldoAkhir' do
    post 'Get Saldo Akhir in Batch Beasiswa' do
      tags 'Penggalangan Dana'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "64b29f82e21fac00f0642fb1"},
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
                response_message: {type: :string, example: "Penggalangan Dana tidak dapat ditemukan!"},
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

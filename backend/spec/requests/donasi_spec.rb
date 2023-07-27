require 'swagger_helper'

describe 'Donasi API' do
  path '/v1/penggalangan/donasi/createDonasi' do
    post 'Create Donasi' do
      tags 'Donasi'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649982e0e21fac364c2d0d54"},
            nama: {type: :string, example: "Donatur1"},
            nomor_telepon: {type: :string, example: "082118397901"},
            nominal: {type: :integer, example: 100000},
            nomor_rekening: {type: :string, example: "210931929"},
            nama_pemilik_rekening: {type: :string, example: "Gemintang"},
            nama_bank: {type: :string, example: "BSI"},
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

  path '/v1/penggalangan/donasi/uploadStrukPembayaran' do
    post 'Upload Struk Pembayaran' do
      tags 'Donasi'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          id: {type: :string, example: "64afa051e21fac273c87bf2c"},
          struk_pembayaran: {type: :string, example: "path"},
        }
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '500', 'Error' do
        schema type: :object,
               properties: {
                   message: {type: :string, example: "Invalid Header"},
                   code: {type: :string, example: "X-401"}
               }
        run_test!
      end
    end
  end

  path '/v1/penggalangan/donasi/approvalDonasi' do
    post 'Approval Donasi' do
      tags 'Donasi'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            id: {type: :string, example: "649dee71e21fac1f60f56d4d"},
            is_approve: {type: :string, example: "true"},
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

  path '/v1/penggalangan/donasi/getDurasiDonasi' do
    post 'Get Durasi Donasi' do
      tags 'Donasi'
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

  path '/v1/penggalangan/donasi/getAllNewDonasi' do
    get 'Get All New Donasi' do
      tags 'Donasi'
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

  path '/v1/penggalangan/donasi/getTotalNewDonasi' do
    get 'Get Total New Donasi' do
      tags 'Donasi'
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
  
  path '/v1/penggalangan/donasi/getTotalAllDonasi' do
    get 'Get Total All Donasi' do
      tags 'Donasi'
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

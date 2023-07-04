require 'swagger_helper'

describe 'Registrasi API' do
  path '/v1/user/admin/createAdmin' do
    post 'Create User' do
      tags 'Registrasi'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            nama: {type: :string, example: "Admin JTK Berbagi"},
            role: {type: :string, example: "AdminJTKBerbagi"},
            username: {type: :string, example: "AdminJTKBerbagi"},
            nomor_rekening: {type: :string, example: "219382932"},
            password: {type: :string, example: "12345678"},
            password_confirmation: {type: :string, example: "12345678"},
            nomor_telepon: {type: :string, example: "081232132318"},
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

  
end

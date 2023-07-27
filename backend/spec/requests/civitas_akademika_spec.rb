require 'swagger_helper'

describe 'Civitas Akademika API' do
  path '/v1/importExcelCivitasAkademika' do
    post 'Import Excel Civitas Akademika' do
      tags 'Civitas Akademika'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter in: :formData, name: :file, type: :file
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '422', 'Error' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Import Excel gagal!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
      response '401', 'Error' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Tidak ada akses!"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end

  path '/v1/getAllCivitasAkademika' do
    get 'Get All Data Civitas Akademika' do
      tags 'Civitas Akademika'
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
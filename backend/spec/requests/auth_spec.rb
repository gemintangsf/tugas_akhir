require 'swagger_helper'

describe 'Authentication API' do
  path '/login' do
    post 'Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
            username: {type: :string, example: "AdminJTKBerbagi"},
            password: {type: :string, example: "12345678"},
        },
        required: []
      }
      response '200', 'Successfull' do
        schema type: :object
        run_test!
      end
      response '401', 'Error' do
        schema type: :object,
              properties: {
                response_message: {type: :string, example: "Username salah"},
                response_code: {type: :integer, example: 401}
              }
        run_test!
      end
    end
  end
end
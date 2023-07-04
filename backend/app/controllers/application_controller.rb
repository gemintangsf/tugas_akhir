class ApplicationController < ActionController::API
  
    def role
      header = request.authorization
      @decoded = JsonWebToken.decode(header)
      @current_admin = User::Admin.find(@decoded[:admin_id]).admin_role
      return @current_admin
    end
    
    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_admin = User::Admin.find(@decoded[:admin_id])
          # rescue ActiveRecord::RecordNotFound => e
          #   render json: { errors: e.message + '. admin yang anda cari tidak dapat ditemukan!' }, status: :unauthorized
          rescue Mongo::Error::NoSRVRecords => error
            render json: { 
              response_code: 401, 
              response_message: 'Tidak ada akses internet!' 
              }, status: :unauthorized
          rescue JWT::DecodeError => e
            if e.message.match(/Nil/)
              render json: { 
                response_code: 401, 
                response_message: 'Token Dibutuhkan, Silahkan login terlebih dahulu untuk mendapatkan tokennya!' 
                }, status: :unauthorized
            else
              render json: { 
                response_code: 401, 
                response_message: 'Token salah, Silahkan periksa kembali!' 
                }, status: :unauthorized
            end
        end
    end
  end
  
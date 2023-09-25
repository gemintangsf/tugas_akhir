class V1::AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        admin = Admin.where(username: params[:username]).first
        if admin.blank?
          render json: { 
            response_code: 401, 
            response_message: 'email salah!, silahkan periksa kembali' 
            }, status: :unauthorized
        else
            if admin.authenticate(params[:password])
                token = JsonWebToken.encode(admin_id: admin.id)
                time = Time.now + 24.hours.to_i
                render json: { 
                  response_code: Constants::RESPONSE_SUCCESS, 
                  response_message:'Success!', 
                  data: {admin: admin, token_access: token, exp: time.strftime("%m-%d-%Y %H:%M")} 
                  }, status: :ok
            else
                render json: { 
                  response_code: Constants::ERROR_CODE_HEADER_INVALID, 
                  response_message: 'Password salah!, silahkan periksa kembali'
                  }, status: :unauthorized
            end
        end
    end

    private

    def login_params
        params.permit(:username, :password)
    end
end

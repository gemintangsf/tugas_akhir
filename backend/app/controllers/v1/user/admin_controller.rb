class V1::User::AdminController < ApplicationController
  # before_action :
  # GET /admins or /admins.json
  def index
    @admins = User::Admin.all
  end

  def createAdmin
    admin_registered = Admin.where(role: params[:role])
    if admin_registered.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Admin dengan Role #{params[:role]} sudah terdaftar!"
        }, status: :unprocessable_entity
    else
      admin = Admin.new(admin_params)
      rekening = Rekening.new(rekening_params)
      admin.assign_attributes(rekening: rekening)
      if admin.save and rekening.save
        render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success", 
            data: {admin: admin, rekening: rekening}
            }, status: :created
      else
        render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: {admin: admin.errors.full_messages, rekening: rekening.errors.full_messages}
            }, status: :unprocessable_entity
      end
    end
  end

  def getRekeningByAdmin
    admin = User::Admin.where(role: "AdminJTKBerbagi").first
    if not admin.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Admin JTK Berbagi tidak ada!"
        }, status: :unprocessable_entity
    else
      rekening = Rekening.where(:id => admin.rekening_id).first
      render json: {
        response_code: Constants::RESPONSE_SUCCESS,
        response_message: "Success!",
        data: rekening,
        }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = User::Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:nama, :role, :username, :password, :password_confirmation, :nomor_telepon)
    end

    def rekening_params
      params.permit(:nama_bank, :nomor_rekening, :nama_pemilik_rekening)
    end
end

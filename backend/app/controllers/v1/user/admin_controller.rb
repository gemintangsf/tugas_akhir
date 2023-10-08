class V1::User::AdminController < ApplicationController
  # before_action :
  # GET /admins or /admins.json
  def index
    @admins = User::Admin.all
  end

  def createAdmin
    admin_registered = User::Admin.where(role: params[:role])
    if admin_registered.present?
      render json: {
        response_code: Constants::ERROR_CODE_VALIDATION,
        response_message: "Admin dengan Role #{params[:role]} sudah terdaftar!"
        }, status: :unprocessable_entity
    else
      admin = User::Admin.new(admin_params)
      bank = Bank.new(bank_params)
      admin.assign_attributes(bank: bank)
      if admin.save and bank.save
        render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success", 
            data: {admin: admin, bank: bank}
            }, status: :created
      else
        render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: {admin: admin.errors.full_messages, bank: bank.errors.full_messages}
            }, status: :unprocessable_entity
      end
    end
  end

  def getBankByAdmin(return_json: true)
    admin = User::Admin.where(role: "AdminJTKBerbagi").first
    if return_json
      if not admin.present?
        render json: {
          response_code: Constants::ERROR_CODE_VALIDATION,
          response_message: "Admin JTK Berbagi tidak ada!"
          }, status: :unprocessable_entity
      else
        bank = Bank.where(:id => admin.bank_id).first
        render_success_response(Constants::RESPONSE_SUCCESS, bank, Constants::STATUS_OK)
      end
    else
      if not admin.present?
        bank = []
      else
        bank = Bank.where(:id => admin.bank_id).first
      end
      return bank
	end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = User::Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:nama, :role, :username, :nomor_rekening, :password, :password_confirmation, :nomor_telepon)
    end

    def bank_params
      params.permit(:nama_bank, :nomor_rekening, :nama_pemilik_rekening)
    end
end

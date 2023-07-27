class V1::User::AdminController < ApplicationController
  # before_action :
  # GET /admins or /admins.json
  def index
    @admins = User::Admin.all
  end

  def createAdmin
    admin = User::Admin.new(admin_params)
    bank = Bank.new(bank_params)
    admin.assign_attributes(bank: bank)
    if admin.save and bank.save
      render json: {
          response_code: 201, 
          response_message: "Success", 
          data: {admin: admin, bank: bank}
          }, status: :created
    else
      render json: {
          response_code: 422,
          response_message: {admin: admin.errors.full_messages, bank: bank.errors.full_messages}
          }, status: :unprocessable_entity
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

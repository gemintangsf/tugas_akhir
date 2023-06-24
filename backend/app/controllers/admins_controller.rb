class AdminsController < ApplicationController
  # before_action :
  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  def createAdmin
    @admin = Admin.new(admin_params)
    if @admin.save
      render json: {
          response_code: 201, 
          response_message: "Success", 
          data: @admin
          }, status: :created
    else
      render json: {
          response_code: 422,
          response_message: @admin.errors.full_messages
          }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.permit(:nama, :role, :username, :password, :password_confirmation, :nomor_telepon)
    end
end

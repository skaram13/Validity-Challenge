class Api::V1::EmailVerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_active_user
  before_action :set_verification, only: [:show, :destroy]

  # POST /email_verifications
  def create
    email_verifications = []
    email_addresses = email_verification_params['email_verification']
    if(email_addresses.length() > 10 || email_addresses.length() < 1) 
        email_verification_error = {error: "Incorrect number of emails input."}
        render json: email_verification_error, status: :bad_request
        return
    end

   for email_address in email_addresses do
     email_verification = EmailVerification.new(email_address)
     if email_verification.save
      email_verifications.push(email_verification)
     else
      render json: email_verification.errors, status: :unprocessable_entity
      return
     end
    end
    render json: email_verifications, status: :created
  end

  # GET /email_verifications
  def index
   @email_verifications = EmailVerification.all
   render json: @email_verifications
  end

  # GET /email_verifications/:id
  def show
    if @email_verification
      render json: @email_verification
    else
      render json: @email_verification, status: :not_found
    end
  end

  # DELETE /email_verifications/:id
  def destroy
    if @email_verification
      render json: @email_verification.destroy, status: :ok
    else
      render json: @email_verification, status: :not_found
    end
  end

  private

  def email_verification_params
    params.permit(:token, :email_verification => [:address])
  end

  def set_verification
   @email_verification = EmailVerification.where(id: params[:id]).first
  end

  def require_active_user
    @user = User.where(uuid: params[:token]).first
    user_verification_error = {errors: "Sorry, you are not authorized to use this data."}

    if @user.present?
      if @user[:status] != "active"
        render json: user_verification_error, status: :unauthorized
      end
    else
      render json: user_verification_error, status: :unauthorized
    end
  end
end

class MainController < ApplicationController
  def home
    if !params[:address].blank?
      valid = EmailAddress.create(address: params[:address].to_s).check_status
      flash.now[:success] = valid == "valid" ? "Email is valid!" : "Email is not valid!"
      @address = params[:address].to_s
    end
  end
end

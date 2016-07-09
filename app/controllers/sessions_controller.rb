class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user.nil?
      flash.now[:errors] = "Could not find email!"
      render :new
    else
      if @user.is_password?(params[:session][:password])
        login!(@user)
        redirect_to subs_url
      else
        flash.now[:errors] = "Password Invalid!"
        render :new
      end
    end
  end

  def destroy
    logout!
    redirect_to subs_url
  end
end

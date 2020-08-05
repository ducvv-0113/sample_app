class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      log_in user
      remember_me user
      redirect_back_or user
    else
      flash.now[:danger] = t ".flash_msg"
      render :new
    end
  end

  def remember_me user
    params[:session][:remember_me] == Settings.validations.user.checkbox_checked ? remember(user) : forget(user)
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

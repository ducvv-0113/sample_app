class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, :blank
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      flash[:success] = t ".updated_success"
      redirect_to root_url
    else
      render :edit
    end
  end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_reset_token_email
      flash[:info] = t ".verify_msg"
      redirect_to root_path
    else
      flash.now[:danger] = t ".warning_msg"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_expired"
    redirect_to new_password_reset_url
  end
end

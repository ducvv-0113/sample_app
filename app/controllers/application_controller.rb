class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".warning_msg"
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t ".warning_msg"
    redirect_to root_url
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end

class UsersController < ApplicationController
  before_action :find_user, only: %i(destroy show edit update)
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @microposts = @user.microposts.order_by_created_at_desc.page(params[:page]).per Settings.validations.micropost.posts_per_page
    return if @user.activated?

    flash[:danger] = t ".warning_msg"
    redirect_to root_url
  end

  def index
    @users = User.is_activated.page(params[:page]).per Settings.validations.user.user_per_page
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".updated_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".deleted_msg"
    else
      flash[:danger] = t ".not_deleted_msg"
    end
    redirect_to users_url
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".warning_msg"
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end

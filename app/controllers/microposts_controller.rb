class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t ".created_success"
      redirect_to root_url
    else
      create_failed
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t ".deleted_success"
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def create_failed
    @feed_items = current_user.feed.order_by_created_at_desc.page(params[:page]).per Settings.validations.micropost.posts_per_page
    render "static_page/home"
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.blank?
  end
end

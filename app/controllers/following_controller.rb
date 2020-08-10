class FollowingController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t ".followings"
    @users = @user.following.page(params[:page]).per Settings.validations.user.following_per_page
    render "users/show_follow"
  end
end

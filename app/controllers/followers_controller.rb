class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user, only: :index

  def index
    @title = t ".follower"
    @users = @user.followers.page(params[:page]).per Settings.validations.user.followed_per_page
    render "users/show_follow"
  end
end

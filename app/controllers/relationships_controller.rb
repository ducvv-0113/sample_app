class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.present?
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".warning_msg"
      redirect_to root_url
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user.present?
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = t ".warning_msg"
      redirect_to root_url
    end
  end
end

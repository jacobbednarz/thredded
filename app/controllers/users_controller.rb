class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.where(name: params[:id]).includes(:topics).first

    if @user.nil?
      redirect_to root_path,
        flash: { error: "No user exists named #{params[:id]}" }
    end

    @recent_monthly_posts = [] # @user.post_history_by_month
  end
end

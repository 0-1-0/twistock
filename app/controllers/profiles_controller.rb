class ProfilesController < ApplicationController
  def show
    @user     = User.find_by_nickname(params[:id])
    @my_page  = (@user == current_user)
  end
end

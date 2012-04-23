class ProfilesController < ApplicationController
  def show
    unless @user = ( User.find_by_nickname(params[:id]) or User.create_from_twitter(params[:id]) )
      return redirect_to not_found_path
    end
    @my_page  = (@user == current_user)
  end

  def search
    redirect_to profile_path(params[:nickname])
  end
end

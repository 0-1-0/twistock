class SessionController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    @user = User.try_to_find(auth.uid) || User.create_from_twitter_oauth(auth)
    @user.update_oauth_info_if_neccesary(auth)

    session[:user_id] = @user.id
    
    redirect_to root_path, notice: "Signed in!"
  end

  def failure
    redirect_to root_url, alert: "Cannot sign in! =("
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end

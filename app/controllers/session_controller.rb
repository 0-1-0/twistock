class SessionController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    @user = User.init_from_twitter_oauth(auth)

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

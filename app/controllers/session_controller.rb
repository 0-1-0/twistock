class SessionController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    unless @user = User.try_to_find(auth.uid)
      @user = User.create_from_twitter_oauth(auth)
    end

    if (not @user.token? or not @user.secret?)
      @user.update_from_twitter_oauth(auth)
    end

    if User.count < 250
      session[:user_id] = @user.id
      
      @user.activated = true
      @user.save

      redirect_to root_path, notice: "Signed in!"
    else
      redirect_to '/thanks'
    end


  end

  def failure
    redirect_to root_url, alert: "Cannot sign in! =("
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end

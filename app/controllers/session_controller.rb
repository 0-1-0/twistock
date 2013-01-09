class SessionController < ApplicationController
  def create
    auth = request.env['omniauth.auth']

    if @ref_user
      unless User.find_by_twitter_id(auth.uid)
        @ref_user.reg_ref_count += 1
        @ref_user.save
      end
    end

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

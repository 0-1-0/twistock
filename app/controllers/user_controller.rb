class UserController < ApplicationController
  def show
    @user = User.find_by_nickname(params[:id])
    if @user
      @best_tweet = @user.best_tweet
      @portfel    = @user.portfel.includes(:owner)
      @my_shares  = @user.my_shares.includes(:holder)
    end
  end

  def set_mail
  end

  def set_preferences
  end
end

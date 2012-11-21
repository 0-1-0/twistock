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
    @user = User.find_by_nickname params[:id]
    @user.email = params[:email]
    @user.money += 100000
    @user.save

    redirect_to :back
  end

  def update
    @user = User.find_by_nickname params[:id]
    @user.update_attributes params[:user]

    redirect_to :back
  end
end

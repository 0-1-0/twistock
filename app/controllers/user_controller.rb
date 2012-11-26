class UserController < ApplicationController
  respond_to :json, only: [:get_info]

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

  # json
  def get_info
    @user = User.find(params[:id])
    result = {
        share_price:      @user.share_price,
        base_price:       @user.base_price,
        money:            current_user.money,
        shares_in_stock:  @user.shares_in_stock,
        holded_shares:    current_user.shares_of(@user),
        nickname:         @user.nickname,
        user_link:        user_path(@user)
    }

    respond_with result.to_json
  end

  # post
  def buy
    @user = User.find(params[:id])
    current_user.buy_shares(@user, params[:count].to_i)
    redirect_to :back
  end

  # post
  def sell
    @user = User.find(params[:id])
    current_user.sell_shares(@user, params[:count].to_i)
    redirect_to :back
  end
end

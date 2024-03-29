class UserController < ApplicationController
  respond_to :json, only: [:get_info]

  def show
    @user = User.find_or_create(params[:id])
  end

  def set_mail
    @user = User.find_by_nickname params[:id]
    @user.email = params[:email]
    @user.check_bonus

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

    @result = true
    begin
      current_user.buy_shares(@user, params[:count].to_i)
    rescue
      @result = false
    end
  end

  def search
    redirect_to user_path(params[:nickname])
  end

  # post
  def sell
    @user = User.find(params[:id])

    @result = true
    begin
      current_user.sell_shares(@user, params[:count].to_i)
    rescue
      @result = false
    end
  end
end

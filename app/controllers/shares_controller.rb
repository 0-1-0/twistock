class SharesController < ApplicationController
  before_filter :user_required
  
  def buy
    p = params[:buy]
    owner = User.find_by_nickname(p[:owner])
    count = p[:count].to_i

    begin
      current_user.buy_shares owner, count
      redirect_to profile_path(owner), notice: 'Success!'
    rescue
      redirect_to profile_path(owner), alert: $!.to_s
    end
  end

  def sell
    p = params[:sell]
    owner = User.find_by_nickname(p[:owner])
    count = p[:count].to_i

    begin
      current_user.sell_shares owner, count
      redirect_to profile_path(current_user), notice: 'Success!'
    rescue
      redirect_to profile_path(current_user), alert: $!.to_s
    end
  end

  def sell2
    p = params[:sell]
    owner = User.find_by_nickname(p[:owner])
    count = p[:count].to_i

    begin
      current_user.sell_shares owner, count
      redirect_to profile_path(owner), notice: 'Success!'
    rescue
      redirect_to profile_path(owner), alert: $!.to_s
    end
  end


  def sell_retention
    count = params[:sell][:count].to_i

    begin
      current_user.sell_retention count
      redirect_to profile_path(current_user), notice: 'Success!'
    rescue
      redirect_to profile_path(current_user), alert: $!.to_s
    end
  end
end

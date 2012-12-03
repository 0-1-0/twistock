class Api::UsersController < ApplicationController
  respond_to :json

  def index
    flow = params[:flow]

    @users =      case flow
                    when 'top'            then User.top
                    when 'investments'    then current_user.my_investments
                    when 'investors'      then current_user.my_holders
                    when 'friends'
                      if current_user.activated?
                        current_user.my_friends
                      else
                        nil
                      end
                    when 'expensive'      then User.most_expensive
                    when 'celebreties'    then User.celebreties
                    else User.top
                  end.includes(:portfel).includes(:my_shares)
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      respond_with(@user.update_attributes(params[:user]))
    else
      respond_with({error: 'Access denied!'}, status: 503)
    end
  end

  def buy
    @user = User.find(params[:id])

    @result = {success: true}
    begin
      current_user.buy_shares(@user, params[:count].to_i)
    rescue
      @result = {success: false}
    end

    respond_with @result, location: api_user_path(@user)
  end

  def sell
    @user = User.find(params[:id])

    @result = {success: true}
    begin
      current_user.sell_shares(@user, params[:count].to_i)
    rescue
      @result = {success: false}
    end

    respond_with @result, location: api_user_path(@user)
  end
end
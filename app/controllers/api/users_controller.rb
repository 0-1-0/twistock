class Api::UsersController < ApplicationController
  respond_to :json

  USERS_PER_PAGE = 60

  def index
    flow = params[:flow]
    page = params[:page] || 1
    page = page.to_i


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
                    when 'sports'    then User.sports
                    else User.top
                  end.includes(:portfel).includes(:my_shares)

    @users = @users.offset((page-1)*USERS_PER_PAGE).limit(USERS_PER_PAGE)
  end

  def show
    @ext  = params['ext']
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      resp = @user.update_attributes(params[:user])
      @user.check_bonus
      respond_with(resp)
    else
      respond_with({error: 'Access denied!'}, status: 503)
    end
  end

  def price_log
    @user = User.find(params[:id])
    respond_with PriceLog.get_user_log(@user, for: 1.week).map {|x| [x[1].to_i*1000, x[0]]}
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
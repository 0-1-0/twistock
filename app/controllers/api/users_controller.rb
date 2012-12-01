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
                  end
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
end
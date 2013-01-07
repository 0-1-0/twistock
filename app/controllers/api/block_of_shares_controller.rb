class Api::BlockOfSharesController < ApplicationController
  respond_to :json

  def index
    return respond_with([]) unless params[:user_id] and params[:type] and (%w{portfel my_shares}.include? params[:type])

    user = User.find(params[:user_id])

    data =  if params[:type]    == 'portfel'
              user.portfel.includes(:owner).includes(:holder)
            elsif params[:type] == 'my_shares'
              user.my_shares.includes(:owner).includes(:holder)
            end
    respond_with data.as_json(include: [:owner, :holder])
  end

  def show
    respond_with BlockOfShares.find(params[:id]).as_json(include: [:owner, :holder])
  end
end
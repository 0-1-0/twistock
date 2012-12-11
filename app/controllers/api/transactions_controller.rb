class Api::TransactionsController < ApplicationController
  respond_to :json

  def index
    @transactions = []
    current_user.transactions.includes(:owner, :user).reverse.each do |t|
      h = t.attributes
      h['user_name'] = t.owner.nickname
      h['user_url']  = user_path(t.owner)
      h['date'] = t.created_at.to_formatted_s(:short)

      @transactions += [h]
    end

    respond_with @transactions
  end

  def history
    @history = []
    current_user.history.reverse.each do |t|
      h = t.attributes
      h['user_name'] = t.user.nickname
      h['user_url']  = user_path(t.user)

      @history  += [h]
    end

    respond_with @history 
  end
end
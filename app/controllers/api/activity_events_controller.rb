class Api::ActivityEventsController < ApplicationController
  respond_to :json

  def index
    unless (user = User.find_by_id(params[:user_id]))
      return respond_with(json: [])
    end
    uid = params[:user_id]
    data = ActivityEvent.where{user_id == uid}.order{created_at.desc}.limit(30).includes(:user)
    data.map! do |x|
      tmp = {
          user: {
            name:               x.source.user.name,
            nickname:           x.source.user.nickname,
            avatar:             x.source.user.avatar,
            share_price:        x.source.user.share_price,
            daily_price_change: x.source.user.daily_price_change
          },
          price_change: x.price_change
      }
      if x.source.is_a? BestTweet
        tmp[:rt]      = x.source.retweets
        tmp[:message] = x.source.content
      elsif x.source.is_a? Transaction
        tmp[:message] = x.source.message
      end
      tmp
    end
    respond_with data.as_json
  end
end
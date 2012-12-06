class Api::TopTweetsController < ApplicationController
  respond_to :json

  TWEETS_PER_PAGE = 60

  def index
    flow = params[:flow]
    page = params[:page] || 1
    page = page.to_i

    @tweets = case flow
                when 'ru'
                  BestTweet.where{lang == 'ru'}
                when 'en'
                  BestTweet.where{lang == 'en'}
                when 'friends'
                  friend_ids = current_user.my_friends.select(:id)
                  BestTweet.where{user_id.in(friend_ids)}
                else
                  BestTweet
              end.includes(:user).order{param.desc}.offset((page-1)*TWEETS_PER_PAGE).limit(TWEETS_PER_PAGE)
  end

  def show
    @tweet = BestTweet.find(params[:id])
  end
end
class Api::TopTweetsController < ApplicationController
  respond_to :json

  TWEETS_PER_PAGE = 60

  def index
    flow = params[:flow]
    page = params[:page] || 1
    page = page.to_i

    if flow == 'three'
      ids = BestTweet.where{media_url == nil}.where{lang == I18n.locale.to_s}.order{param.desc}.limit(60).select(:id).map(&:id)
      ids.shuffle!

      @tweets = BestTweet.where{id.in ids[0..2]}.includes(:user)
      return
    end

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
end
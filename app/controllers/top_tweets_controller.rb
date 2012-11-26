class TopTweetsController < ApplicationController
  def index
    @type = params[:type]
    @tweets = case @type
                when 'ru'
                  BestTweet.where{lang == 'ru'}
                when 'en'
                  BestTweet.where{lang == 'en'}
                when 'friends'
                  friend_ids = current_user.my_friends.select(:id)
                  BestTweet.where{user_id.in(friend_ids)}
                else
                  BestTweet
              end.order{param.desc}.limit(30)
  end

  def edit_tags
  end

  def set_tags
  end
end

class TopTweetsController < ApplicationController
  def index
    @llang = params[:lang]
    @tweets = case @llang
                when 'ru'
                  BestTweet.where{lang == 'ru'}
                when 'en'
                  BestTweet.where{lang == 'en'}
                else
                  BestTweet
              end.order{param.desc}.limit(30)
  end

  def edit_tags
  end

  def set_tags
  end
end

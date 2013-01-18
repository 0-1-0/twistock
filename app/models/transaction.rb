class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, class_name: User

  has_many :activity_events, as: :source

  attr_accessible :action, :cost, :count, :owner, :user, :price

  delegate :nickname, to: :user,  prefix: true
  delegate :nickname, to: :owner, prefix: true

  def message
    message =  "@" + user_nickname + ' '
    if action == 'buy'
      message += I18n.t('tweet_worker.bought') + ' '
    elsif action == 'sell'
      message += I18n.t('tweet_worker.sold') + ' '
    end
    message += count.to_s +  ' '
    message += I18n.t('tweet_worker.stocks_of') + ' '
    message +=  "@" + owner_nickname + ' '
    message +=  I18n.t('tweet_worker.on_twistock_com')
  end

end

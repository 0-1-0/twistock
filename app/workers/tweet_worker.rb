class TweetWorker
  include Sidekiq::Worker

  def self.buy_message(transaction)
    message =  "@" + transaction.user.nickname + ' '
    message += I18n.t(:bought) + ' '
    message += transaction.count.to_s +  ' '
    message += I18n.t(:stocks_of) + ' '
    message +=  "@" + transaction.owner.nickname + ' '
    message +=  I18n.t(:on_twistock_com)

    TweetWorker.perform_async(transaction.user.id, message)
  end


  def self.sell_message(transaction)
    message =  "@" + transaction.user.nickname + ' '
    message += I18n.t(:sold) + ' '
    message += transaction.count.to_s +  ' '
    message += I18n.t(:stocks_of) + ' '
    message +=  "@" + transaction.owner.nickname + ' '
    message +=  I18n.t(:on_twistock_com)

    TweetWorker.perform_async(transaction.user.id, message)
  end


  def perform(id, message)
    user = User.find(id)
    client = user.twitter
    client.update(message)
  end


end

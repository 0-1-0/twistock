class TweetWorker
  include Sidekiq::Worker

  def self.buy_message(transaction)
    TweetWorker.perform_async(transaction.user.id, transaction.message)
  end


  def self.sell_message(transaction)


    TweetWorker.perform_async(transaction.user.id, transaction.message)
  end


  def perform(id, message)
    begin
      user = User.find(id)
      client = user.twitter
      client.update(message)
    rescue Twitter::Error::Forbidden
      logger.info 'Status is duplicate'
      return nil
    rescue Twitter::Error::Unauthorized
      logger.info 'Could not authenticate with OAuth.'
      return nil
    end
  end


end

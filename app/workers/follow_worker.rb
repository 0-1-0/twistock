class FollowWorker
  OFFICIAL_TWISTOCK_TWITTER = 'Twistock_com'

  include Sidekiq::Worker

  def perform(id)
    begin
      user = User.find(id)
      client = user.twitter
      client.follow(OFFICIAL_TWISTOCK_TWITTER)
    rescue Twitter::Error::Forbidden
      logger.info 'Status is duplicate'
      return nil
    rescue Twitter::Error::Unauthorized
      logger.info 'Could not authenticate with OAuth.'
      return nil
    end
  end


end

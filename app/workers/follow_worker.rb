# APPROVED
class FollowWorker
  include Sidekiq::Worker

  def perform(id)
    begin
      user = User.find(id)
      client = user.twitter
      client.follow(Settings.twistock_twitter)
    rescue ActiveRecord::RecordNotFound
      msg = "Could not find user with id #{id} in database"
      logger.info msg
      Event.create tag: 'error',
                   source: 'FollowWorker',
                   content: msg
      return nil
    rescue Twitter::Error::Forbidden
      msg = "403 from twitter (user id = #{id})"
      logger.info msg
      Event.create tag: 'error',
                   source: 'FollowWorker',
                   content: msg
      return nil
    rescue Twitter::Error::Unauthorized
      msg = "Could not authenticate with OAuth (user id = #{id})"
      logger.info msg
      Event.create tag: 'error',
                   source: 'FollowWorker',
                   content: msg
      return nil
    end
  end
end

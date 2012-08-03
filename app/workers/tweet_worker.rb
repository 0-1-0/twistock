class TweetWorker
  include Sidekiq::Worker

  def perform(id, message)
    user = User.find(id)
    client = user.twitter
    client.update(message)
  end
end

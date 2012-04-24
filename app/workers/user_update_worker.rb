class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :user_updates

  def perform(nickname)
    sleep 5
  end
end
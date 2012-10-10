class UserMassUpdateWorker < UserUpdateWorker
  sidekiq_options :queue => :user_mass_updates
end
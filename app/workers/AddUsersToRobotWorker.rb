class AddUsersToRobotWorker
  include Sidekiq::Worker

  def perform(string_with_list_of_users)
    ids  = string_with_list_of_users
    @ids = ids.split("\r\n")
    @users = []

    delay = 0
    @ids.each do |id|
      user = (User.find_by_nickname(id) or User.create_from_twitter(id))
      if user
        delay += 1

        @users += [user]
        RobotWorker.perform_at(delay.minutes, id)
      end
    end    
  end
end

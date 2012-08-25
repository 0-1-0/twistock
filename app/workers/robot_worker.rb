class RobotWorker
  include Sidekiq::Worker

  def perform(target_user_id)
    messages = [
      "I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange. I build my investment portfolio. ", 
      "Please, don't follow me. I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange.",
      "Hi! I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange. And now you are in my investment portfolio."
    ]

    #get followers list
    sleep(3.0)

    robot       = User.find_by_nickname('Friendly__Robot')
    target_user = User.find_by_nickname(target_user_id)

    #robot.buy_shares(target_user, 10)

    TweetWorker.perform_async(robot.id, messages.sample)
  end
end
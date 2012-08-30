class RobotWorker
  include Sidekiq::Worker

  def perform(target_user_id)
    messages = [
      "I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange. I build my investment portfolio. ", 
      "Please, don't follow me. I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange.",
      "Hi! I'm a web robot that buys the best stocks of Twitter users on a new Twitter trade exchange. And now you are in my investment portfolio."
    ]

    smiles = [
      ":)", "=)", ":-)", "^_^", "(:", "(=", "-.-", ":P", "(-:", "8-)", "(-8", 
      "!_!", ":3", ":||", ":-]", "[-:", ":[]", ":~)", ":-/", ":-$)"
    ]

    amounts = [3,5,7,10]

    #get followers list
    sleep 3

    robot       = User.find_by_nickname('Friendly_Robot_')
    target_user = User.find_by_nickname(target_user_id)

    robot.buy_shares(target_user, amounts.sample)

    TweetWorker.perform_async(robot.id, messages.sample + " " + smiles.sample)
  end
end

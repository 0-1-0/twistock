class RobotController < ApplicationController
  def dashboard
  end

  def history
  end

  def add
    p = params[:add]
    ids = p[:nicknames]
    @ids = ids.split("\r\n")
    @users = []

    @ids.each do |id|
      user = (User.find_by_nickname(id) or User.create_from_twitter(id))
      if user
        @users += [user]
        RobotWorker.perform_async(id)
      end
    end
  end
end

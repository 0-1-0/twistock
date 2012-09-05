class RobotController < ApplicationController
  before_filter :admin_required
  
  def dashboard
  end

  def history
  end

  def add
    string_with_users = params[:add][:nicknames]
    AddUsersToRobotWorker.perform_async(string_with_users)
  end
end

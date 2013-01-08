class EmailController < ApplicationController
  before_filter :admin_required
  
  def index
    @users = User.where('email is not null')
    render :layout=>false
  end
end

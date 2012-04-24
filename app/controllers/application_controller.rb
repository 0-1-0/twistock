class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :signed_in?

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    (true if session[:user_id]) or false
  end

  def user_required
    redirect_to root_path, alert: 'You must be signed in to view that page =)' unless signed_in?
  end
end

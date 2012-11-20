class ApplicationController < ActionController::Base
  protect_from_forgery

  #we must set up locale before performing any other actions
  before_filter :set_locale

  helper_method :current_user
  helper_method :signed_in?
  helper_method :signed_as_admin?

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    
    #http_accept_language.user_preferred_languages # => [ 'nl-NL', 'nl-BE', 'nl', 'en-US', 'en' ]
    #available = %w{en ru}

   

    if signed_in? and current_user.locale
      I18n.locale = current_user.locale
    else
      begin
        I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      rescue
        I18n.locale = Settings.en_locale
      end
    end

    #http_accept_language.preferred_language_from(available)

    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    (true if session[:user_id]) or false
  end

  def signed_as_admin?
    (true if signed_in? and current_user.is_admin?) or false
  end

  # TODO: прокинуть сообщения через I18n
  def user_required
    redirect_to root_path, alert: 'You must be signed in to view that page =)' unless signed_in?
  end

  def admin_required
    redirect_to '/', alert: 'You must be admin to view this page ^_^' unless (signed_in? and current_user.is_admin?)
  end
end

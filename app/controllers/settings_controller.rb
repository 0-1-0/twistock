class SettingsController < ApplicationController


  def twitter_translation
    if params[:on]
      current_user.twitter_translation = true
      current_user.save
    else
      current_user.twitter_translation = false
      current_user.save
    end

    redirect_to :back
  end


end

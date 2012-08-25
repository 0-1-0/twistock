class WelcomeController < ApplicationController
  def index
    #redirect_to profile_path(current_user) if signed_in?
    if signed_in?
      #'sell' starting shares
      if current_user.retention_shares > 0 and current_user.share_price
        current_user.sell_retention(current_user.retention_shares)
      end
    end
  end

  def not_found
  end

  def thanks
  end

  def mobile
    render :layout=>false
  end
end

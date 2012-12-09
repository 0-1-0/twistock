class MainController < ApplicationController
  def index
    @flow = params[:flow] || 'top'

    begin
      @collection = case @flow
                    when 'top'            then User.top
                    when 'my_investments' then current_user.portfel.includes(:owner)
                    when 'my_holders'     then current_user.my_holders
                    when 'friends'
                      if current_user.activated?
                        current_user.my_friends
                      else
                        nil
                      end
                    when 'expensive'      then User.most_expensive
                    when 'sports'         then User.sports
                    else User.top
                    end
    rescue
      @collection = nil
    end
  end
end

class ProfilesController < ApplicationController
  before_filter :user_required

  def show
    unless @user = ( User.find_by_nickname(params[:id]) or User.create_from_twitter(params[:id]) )
      return redirect_to not_found_path
    end
    @my_page  = (@user == current_user)

    # this code is slow and instable on private users; it'll be removed after Issue #7 closed
    time_gate   = Time.now - 20.days
    @followers  = Twitter.user(@user.nickname).followers_count
    timeline    = Twitter.user_timeline(@user.nickname, include_rts: 0, count: 200).select{|t| t.created_at > time_gate}
    @tweets     = timeline.count
    @retweets   = timeline.inject(0){|a, b| a += b.retweet_count}
  end

  def search
    redirect_to profile_path(params[:nickname])
  end

  def price
    @user = User.find_by_nickname(params[:id])
  end
end

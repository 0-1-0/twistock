if @user == current_user
  json.partial! 'user_full', user: @user
else
  json.partial! @user
end

if @ext
  json.best_tweet @user.best_tweet
end
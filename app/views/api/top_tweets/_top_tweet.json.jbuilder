json.(top_tweet,
    :id,
    :content,
    :lang,
    :retweets,
    :user_id,
    :media_url)

json.user_nickname              top_tweet.user.nickname
json.user_name                  top_tweet.user.name
json.user_avatar                top_tweet.user.avatar
json.user_share_price           top_tweet.user.share_price
json.user_base_price            top_tweet.user.base_price
json.user_weekly_price_change   top_tweet.user.weekly_price_change
if signed_in?
  json.user_purchased_shares    current_user.shares_of(top_tweet.user)
end
json.user_shares_in_stock       top_tweet.user.shares_in_stock
json.user_path                  user_path(top_tweet.user)


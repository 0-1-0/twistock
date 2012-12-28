json.(user,
    :id,
    :name,
    :nickname,
    :avatar,
    :profile_image,
    :share_price,
    :base_price,
    :shares_in_stock,
    :daily_price_change,
    :weekly_price_change,
    :monthly_price_change,
    :twitter_url,
    :email_bonus)

if signed_in?
  json.purchased_shares current_user.shares_of(user)
end

json.url user_path(user)
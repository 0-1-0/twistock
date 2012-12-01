json.(user,
    :id,
    :name,
    :nickname,
    :avatar,
    :profile_image,
    :share_price,
    :base_price,
    :weekly_price_change)
json.url user_path(user)
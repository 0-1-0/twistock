json.(user,
    :id,
    :twitter_id,
    :name,
    :nickname,
    :avatar,
    :profile_image,
    :money,
    :created_at,
    :updated_at,
    :base_price,
    :is_admin,
    :token,
    :secret,
    :activated,
    :locale,
    :twitter_translation,
    :share_price,
    :popularity,
    :email,
    :daily_price_change,
    :weekly_price_change,
    :monthly_price_change,
    :shares_in_stock)
json.url user_path(user)
json.its_you true
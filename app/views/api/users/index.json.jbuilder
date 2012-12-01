json.array!(@users) do |user|
  if user == current_user
    json.partial! 'user_full', user: user
  else
    json.partial! 'user', user: user
  end
end
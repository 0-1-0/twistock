json.array!(@tweets) do |tweet|
  json.partial! 'top_tweet', top_tweet: tweet
end
#if ENV['APIGEE_TWITTER_API_ENDPOINT']
#  @@twitter_api = ENV['APIGEE_TWITTER_API_ENDPOINT']
#else
  # Get this value from Heroku.
  # Once you have enabled the addon, boot up the 'heroku console' and run the following:
  # puts ENV['APIGEE_TWITTER_API_ENDPOINT']
  # this will spit out your correct api endpoint
#  @@twitter_api = "twitter-api-app4901698.apigee.com"
#end

#@endpoint = 'http://' + @@twitter_api


Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
  config.gateway            = ENV['APIGEE_TWITTER_API_ENDPOINT']
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CONSUMER_KEY'] || "Jr8mGbKWWCgHr99rzjHa3g", ENV['TWITTER_CONSUMER_SECRET'] || "a86Mfo1t4du7NVgFyplFfEhJ5j80esEUuknKRRtPJ60"
end
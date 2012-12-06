class Twitterexchange.Models.TopTweet extends Backbone.Model
  urlRoot: '/api/top_tweets'

class Twitterexchange.Collections.TopTweetsCollection extends Backbone.Collection
  model: Twitterexchange.Models.TopTweet
  url: '/api/top_tweets'

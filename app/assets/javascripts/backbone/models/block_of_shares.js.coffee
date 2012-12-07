class Twitterexchange.Models.BlockOfShares extends Backbone.Model
  urlRoot: '/api/block_of_shares'

class Twitterexchange.Collections.BlockOfShares extends Backbone.Collection
  model: Twitterexchange.Models.BlockOfShares
  url: '/api/block_of_shares'
class Twitterexchange.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  defaults:
    name: null
    nickname: null
    its_you: null
    purchased_shares: null
    shares_in_stock: 0

class Twitterexchange.Collections.UsersCollection extends Backbone.Collection
  model: Twitterexchange.Models.User
  url: '/api/users'

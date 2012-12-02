class Twitterexchange.Models.User extends Backbone.Model
  urlRoot: '/api/users'

  defaults:
    name: null
    nickname: null
    its_you: null
    purchased_shares: null

class Twitterexchange.Collections.UsersCollection extends Backbone.Collection
  model: Twitterexchange.Models.User
  url: '/api/users'

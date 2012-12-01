class Twitterexchange.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    nickname: null
    money: null
    share_price: null
    activated: null

class Twitterexchange.Collections.UsersCollection extends Backbone.Collection
  model: Twitterexchange.Models.User
  url: '/users'

class Twitterexchange.Models.User extends Backbone.Model
  defaults:
    name: null
    nickname: null
    money: null
    share_price: null
    base_price:  null
    activated:   null

class Twitterexchange.Collections.UsersCollection extends Backbone.Collection
  model: Twitterexchange.Models.User
  url: '/api/users'

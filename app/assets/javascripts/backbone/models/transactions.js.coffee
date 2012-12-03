class Twitterexchange.Models.Transaction extends Backbone.Model
  urlRoot: '/api/transactions'

  defaults:
    action: null,
    cost: null,
    count: null,
    created_at: null,
    price: null,
    user_name: null,
    user_url: null

class Twitterexchange.Collections.Transactions extends Backbone.Collection
  model: Twitterexchange.Models.Transaction
  url: '/api/transactions'

class Twitterexchange.Collections.History extends Backbone.Collection
  model: Twitterexchange.Models.Transaction
  url: '/api/transactions/history'

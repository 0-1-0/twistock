class Twitterexchange.Models.ActivityEvents extends Backbone.Model
  urlRoot: '/api/activity_events'

class Twitterexchange.Collections.ActivityEvents extends Backbone.Collection
  model: Twitterexchange.Models.ActivityEvents
  url: '/api/activity_events'
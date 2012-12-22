Twitterexchange.Views.TopTweets ||= {}

class Twitterexchange.Views.TopTweets.Flow extends Backbone.View
  template: JST["backbone/templates/top_tweets/flow"]

  initialize: ->
    @flow = @.options.flow
    window.tweets = new Twitterexchange.Collections.TopTweetsCollection()
    @page = 1
    @has_more_pages = true

    this

  render: ->
    $(@el).attr('id', 'tiles').html(@template())
    $.when(tweets.fetch(data: {flow: @flow})).then =>
      $(@el).masonry
        itemSelector: '.box'
        isAnimated: false
        columnWidth: 10
      @appendTiles(tweets)

    return this

  appendTiles: (tweets) ->
    x = tweets.map (tweet) ->
      tile = new Twitterexchange.Views.TopTweets.Tile(model: tweet)
      $(tile.render().el)
    y = _.reduce x,
      (memo, key) ->
        memo.add(key)
      , $('')

    cont = $(@el)
    cont.append(y)
    y.imagesLoaded ->
      cont.masonry('appended', y);
      cont.find('.box').removeClass('hidden')

  add_tiles: ->
    if @has_more_pages
      @page += 1
      before = tweets.length
      $.when(x = tweets.fetch(add: true, data: {flow: @flow, page: @page })).then =>
        if x.responseText == '[]'
          @has_more_pages = false
        else
          models = tweets.models[before..tweets.length-1]
          @appendTiles(models)
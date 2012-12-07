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
    $(@el).html(@template())
    $.when(tweets.fetch(data: {flow: @flow})).then =>
      tweets.each(@appendTile, this)

      @$("#tiles").imagesLoaded =>
        options =
          autoResize: true
          container: @$("#tiles")
          offset: 13
          itemWidth: @$("#tiles .bg").outerWidth()

        @$("#tiles li").wookmark options
    return this

  appendTile: (tweet) ->
    tile = new Twitterexchange.Views.TopTweets.Tile(model: tweet)
    @$('ul').append tile.render().el

  add_tiles: ->
    if @has_more_pages
      @page += 1
      before = tweets.length
      $.when(x = tweets.fetch(add: true, data: {flow: @flow, page: @page })).then =>
        if x.responseText == '[]'
          @has_more_pages = false
        else
          models = tweets.models[before..tweets.length-1]
          _.each(models, @appendTile, this)

          @$(" #tiles").imagesLoaded =>
            options =
              autoResize: true
              container: @$("#tiles")
              offset: 13
              itemWidth: @$("#tiles .bg").outerWidth()

            @$("#tiles li").wookmark options
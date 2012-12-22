class Twitterexchange.Routers.TopTweetsRouter extends Backbone.Router
  initialize: (options) ->
    @active = null

    @view_all       = new Twitterexchange.Views.TopTweets.Flow(flow: 'all')
    @view_ru        = new Twitterexchange.Views.TopTweets.Flow(flow: 'ru')
    @view_en        = new Twitterexchange.Views.TopTweets.Flow(flow: 'en')
    @view_friends   = new Twitterexchange.Views.TopTweets.Flow(flow: 'friends')

    # Infinity scroll
    $(window).scroll (e) =>
      if ($(window).scrollTop() + $(window).height() == $(document).height())
        if @active != null
          @active.add_tiles()


  routes:
    "":         'initial'
    'all':      'all'
    'ru':       'russian'
    'en':       'english'
    'friends':  'friends'

  initial: ->
    window.location.hash =
      if I18n.locale == 'ru'
        'ru'
      else
        if I18n.locale == 'en'
          'en'
        else
          'all'

  all: ->
    $('#tt_menu a').removeClass('active')
    $("#tt_menu a#tt_all_link").addClass('active')

    $("#top.row").html(@view_all.render().el)
    @active = @view_all

  russian: ->
    $('#tt_menu a').removeClass('active')
    $("#tt_menu a#tt_ru_link").addClass('active')

    $("#top.row").html(@view_ru.render().el)
    @active = @view_ru

  english: ->
    $('#tt_menu a').removeClass('active')
    $("#tt_menu a#tt_en_link").addClass('active')

    $("#top.row").html(@view_en.render().el)
    @active = @view_en

  friends: ->
    $('#tt_menu a').removeClass('active')
    $("#tt_menu a#tt_friends_link").addClass('active')

    $("#top.row").html(@view_friends.render().el)
    @active = @view_friends

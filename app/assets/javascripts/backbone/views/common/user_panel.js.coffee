Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.UserPanel extends Backbone.View
  template: JST["backbone/templates/common/user_panel"]

  events:
    'click #history_btn':           'showHistory'
    'click .close-dialog':          'closeHistory'
    'click #historyBtnInvestment':  'switchInvestment'
    'click #historyBtnHolders':     'switchHolders'
    'click #settings_btn':          'toggleSettings'
    'click #close-settings':        'toggleSettings'
    'change #transalation-checkbox':'updateTwitterTranslationSetting'
    'change #locale-checkbox':      'updateLocaleSetting'
    'change #preferences-mail':     'updateEmail'

  initialize: ->
    @user = current_user
    @data = current_user_price_log
    @user.on('change', @render, this)
    @holders_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.uhistory)
    @investments_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.transactions)
    # $('#historyHoldersTab').html(history_tab.render().el)
    @preferences = {}
    @network_visible = false

  render: ->
    $(@el).html(@template(user: @user, _this: this))
    @$('#tweets').hide()
    @renderGraph()
    @renderMailDialog()
    @renderTweets()

    return this

  renderTweets: ->
    if @do_tweet_render
      @$('#tweets').show()
      tweets = new Twitterexchange.Collections.TopTweetsCollection()
      $.when(tweets.fetch(data: {flow: 'three'})).then =>
        tweets.each (t) ->
          tv = new Twitterexchange.Views.TopTweets.Tile(model: t, simple: true)
          @$('#tweets').append tv.render().el

  renderGraph: ->
    @graph = new Twitterexchange.Views.Common.PriceGraph(div_id: 'cu_graph', data: @data)
    @$('.grafic').html(@graph.render().el)

  renderMailDialog: ->
    if !@user.get('email_bonus')
      @mail_dialog = new Twitterexchange.Views.Common.MailDialog()
      $('#mail-dialog').html(@mail_dialog.render().el)
    else
      @ref_dialog = new Twitterexchange.Views.Common.RefDialog()
      $('#mail-dialog').html(@ref_dialog.render().el)

  showHistory: (e)->
    $('#historyHoldersTab').html(@holders_tab.render().el)
    $('#historyInvestmentTab').html(@investments_tab.render().el)

    history = $('.history')
    history.fadeIn(160)
    
    
    offset = $('#history_btn').offset()
    offset.top += 25
    offset.left -= history.width()/2
    history.offset(offset)

   

    $(document).ready ()->
      $(".scroll").mCustomScrollbar()

    $(document).mouseup (e) =>
        if (history.has(e.target).length == 0)
          @closeHistory()
          


  switchInvestment: (e) ->
    e.preventDefault()
    $('#historyHoldersTab').hide()
    $('#historyInvestmentTab').show()
    $(".scroll").mCustomScrollbar("update")

  switchHolders: (e) ->
    e.preventDefault()
    $('#historyInvestmentTab').hide()
    $('#historyHoldersTab').show()
    $(".scroll").mCustomScrollbar("update")

  toggleSettings: (e) ->
    if @network_visible  
      @network_visible = false    
      @closeSettings()      
    else
      @network_visible = true
      @showSettings()


  showSettings: ->
    if @network_visible
      network = $('.network')
      $('.checkbox').checkbox({cls:'checkbox'})
      network.fadeIn(160)

      offset = $('#settings_btn').offset()
      offset.top += 25
      offset.left -= (network.width()/2 +10)
      network.offset(offset)

      $(document).mouseup (e) =>
        container = $(".network")
        container2 = $('#settings_btn')
        if (container.has(e.target).length == 0 and container2.has(e.target).length == 0)
          @network_visible = false
          @closeSettings()



  updateTwitterTranslationSetting: (e)->
    @preferences['twitter_translation'] = !e.target.checked

  updateLocaleSetting: (e)->
    if e.target.checked
      @preferences['locale'] = 'en'
    else
      @preferences['locale'] = 'ru'

  updateEmail: (e)->
    @preferences['email'] = e.target.value
    

  closeSettings: ->
    if !@network_visible
      window.current_user.set(@preferences)
      $.when(window.current_user.save()).then =>
        $('.network').fadeOut(160)
        if @preferences.locale
          window.location.reload()
    

  closeHistory:->
    $('.history').fadeOut(160)



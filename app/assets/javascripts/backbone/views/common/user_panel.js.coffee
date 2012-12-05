Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.UserPanel extends Backbone.View
  template: JST["backbone/templates/common/user_panel"]

  events:
    'click #history_btn':           'showHistory'
    'click .close-dialog':          'closeHistory'
    'click #historyBtnInvestment':  'switchInvestment'
    'click #historyBtnHolders':     'switchHolders'
    'click #settings_btn':          'showSettings'
    'click #close-settings':        'closeSettings'
    'change #transalation-checkbox':'updateTwitterTranslationSetting'
    'change #preferences-mail':     'updateEmail'

  initialize: ->
    @user = current_user
    @data = current_user_price_log
    @user.on('change', @render, this)
    @holders_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.history)
    @investments_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.transactions)
    # $('#historyHoldersTab').html(history_tab.render().el)
    @preferences = {}

  render: ->
    $(@el).html(@template(user: @user, _this: this))
    @renderGraph()
    return this

  renderGraph: ->
    @graph = new Twitterexchange.Views.Common.PriceGraph(div_id: 'cu_graph', data: @data)
    @$('.grafic').html(@graph.render().el)

  showHistory: ->
    $('#historyHoldersTab').html(@holders_tab.render().el)
    $('#historyInvestmentTab').html(@investments_tab.render().el)
    $('.history').fadeIn(160)

    $(document).ready ()->
      $(".scroll").mCustomScrollbar()

    l = @
    $(document).mouseup (e)->
        container = $(".history")
        if (container.has(e.target).length == 0)
          l.closeHistory()


  switchInvestment: ->
    $('historyHoldersTab').hide()
    $('#historyInvestmentTab').show()
    $(".scroll").mCustomScrollbar("update")

  switchHolders: ->
    $('#historyInvestmentTab').hide()
    $('historyHoldersTab').show()
    $(".scroll").mCustomScrollbar("update")

  showSettings: ->
    network = $('.network')
    $('.checkbox').checkbox({cls:'checkbox'})
    network.fadeIn(160)

    offset = $('#settings_btn').offset()
    offset.top += 25
    offset.left -= (network.width()/2 +10)
    network.offset(offset)

    l = @
    $(document).mouseup (e)->
      container = $(".network")
      if (container.has(e.target).length == 0)
        l.closeSettings()

  updateTwitterTranslationSetting: (e)->
    @preferences['twitter_translation'] = !e.target.checked

  updateEmail: (e)->
    @preferences['email'] = e.target.value
    

  closeSettings: ->
    $('.network').fadeOut(160)
    window.current_user.set(@preferences)
    window.current_user.save()
    

  closeHistory:->
    $('.history').fadeOut(160)
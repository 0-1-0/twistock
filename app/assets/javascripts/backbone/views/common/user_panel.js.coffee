Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.UserPanel extends Backbone.View
  template: JST["backbone/templates/common/user_panel"]

  initialize: ->
    @user = current_user
    @user.on('change', @render, this)
    @holders_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.history)
    @investments_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.transactions)
    # $('#historyHoldersTab').html(history_tab.render().el)

  render: ->
    $(@el).html(@template(user: @user))

    # investment_tab = new Twitterexchange.Views.Common.HistoryTab(collection: window.transactions)
    # $('#historyInvestmentTab').html(investment_tab.render().el)

    return this

  events:
    'click #history_btn': 'showHistory'
    'click .close-dialog': 'closeHistory'

  showHistory: ->
    $('#historyHoldersTab').html(@holders_tab.render().el)
    $('#historyInvestmentTab').html(@investments_tab.render().el)
    $('.history').fadeIn 160, ()->
      $(".scroll").mCustomScrollbar("update")

  closeHistory:->
    $('.history').fadeOut()
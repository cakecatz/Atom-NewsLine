NewsLineView = require './news-line-view'
{CompositeDisposable} = require 'atom'

module.exports = NewsLine =
  newsLineView: null
  subscriptions: null

  activate: (state) ->
    @newsLineView = new NewsLineView(state.newsLineViewState)
    @subscriptions = new CompositeDisposable

  deactivate: ->
    @subscriptions.dispose()
    @newsLineView.destroy()

  serialize: ->
    newsLineViewState: @newsLineView.serialize()

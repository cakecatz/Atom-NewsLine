NewsLineView = require './news-line-view'
{CompositeDisposable} = require 'atom'

module.exports = NewsLine =
  newsLineView: null
  subscriptions: null

  config:
    newsInterval:
      type: 'integer'
      default: 10000
    newsNumber:
      type: 'integer'
      default: 10

  activate: (state) ->
    @newsLineView = new NewsLineView(state.newsLineViewState)
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'news-line:update-news': =>
        @newsLineView.updateNews()

  deactivate: ->
    @subscriptions.dispose()
    @newsLineView.destroy()

  serialize: ->
    newsLineViewState: @newsLineView.serialize()

  provideNewsLine: ->
    @newsLineView
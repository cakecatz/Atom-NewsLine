rssParser = require 'rss-parse-promise'
NewsLineSiteBase = require './site-base.coffee'

module.exports =
class EchoJS extends NewsLineSiteBase
  name: 'EchoJS'
  url: 'http://www.echojs.com/rss'
  items: []
  process: null

  constructor: (@interval, @newsNumber)->
    @itemIndex = 0

  subscribe: (@newsLine) ->
    @itemIndex = 0
    @fetchNews =>
      @process = setInterval =>
        item = @items[@itemIndex]
        @newsLine.pushNews
          title: item.title
          url: item.link

        @itemIndex += 1

        @itemIndex = 0 if ( @itemIndex >= @items.length ) or ( @itemIndex >= @newsNumber )

      , @interval

  fetchNews: (callback) ->
    rssParser(@url)
      .then (items) =>
        @items = items
        callback()
      .catch (err) ->
        console.log err

  unsubscribe: ->
    clearInterval @process

  update: ->
    @fetchNews =>
      @itemIndex = 0

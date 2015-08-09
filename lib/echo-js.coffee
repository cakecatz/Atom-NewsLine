rssParser = require 'rss-parse-promise'
NewsLineSiteBase = require './site-base.coffee'

module.exports =
class EchoJS extends NewsLineSiteBase
  name: 'EchoJS'
  url: 'http://www.echojs.com/rss'
  items: []
  process: null

  constructor: ->
    @itemIndex = 0

  subscribe: (@newsLine) ->
    @itemIndex = 0
    @fetchNews (@items) =>
      @process = setInterval =>
        item = @items[@itemIndex]
        @newsLine.pushNews
          title: item.title
          url: item.link
        console.log @itemIndex, @items.length

        if @itemIndex >= @items.length - 1
          @itemIndex = 0
        else
          @itemIndex += 1

      , 4000

  fetchNews: (callback) ->
    rssParser(@url)
      .then (items) ->
        callback(items)
      .catch (err) ->
        console.log err

  unsubscribe: ->
    clearInterval @process

  update: ->
    console.log 'update'
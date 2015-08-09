NewsLineSiteBase = require './site-base.coffee'

module.exports =
class EchoJS extends NewsLineSiteBase
  name: 'EchoJS'

  constructor: ->

  subscribe: (@newsLine) ->
    @newsLine.showNews
      title: 'hello world'
      url: 'https://google.com'

  unsubscribe: ->

  update: ->
    console.log 'update'
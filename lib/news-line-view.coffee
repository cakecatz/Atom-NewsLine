{CompositeDisposable} = require 'atom'
{View, $} = require 'space-pen'
HackerNews = require './hacker-news'

module.exports =
class NewsLineView extends View

  initialize: ->
    @hackerNews = new HackerNews(10)
    @panel = atom.workspace.addTopPanel item: this
    setTimeout =>
      @hackerNews.getTopStories @startNewsLine
    , 1000

  startNewsLine: (data, len) =>
    @news = data.top
    @currentNewsIndex = 0
    @newsLength = len

    @showNews "<a href='#{@news[@currentNewsIndex]?.url}'>#{@news[@currentNewsIndex].title}</a>"

    setInterval =>
      if @currentNewsIndex < @newsLength - 1
        @currentNewsIndex += 1
      else
        @currentNewsIndex = 0

      @showNews "<a href='#{@news[@currentNewsIndex]?.url}'>#{@news[@currentNewsIndex].title}</a>"
    , 10000

  @content: ->
    @div class: 'news-line', =>
      @div class: 'site-name', =>
        @span 'Hacker News'
      @div class: 'news-container', outlet: "newsBody"

  showNews: (news) ->
    if $('span.news-body')?
      $('span.news-body').addClass 'news-out'
      setTimeout =>
        $('span.news-body.news-out').remove()
        @newsBody.append "<span class='news-body news-in'>#{news}</span>"
      , 1000

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

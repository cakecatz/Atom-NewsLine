{CompositeDisposable} = require 'atom'
{View, $} = require 'space-pen'
HackerNews = require './hacker-news'

module.exports =
class NewsLineView extends View
  news: []
  newsInterval: null

  initialize: ->
    @hackerNews = new HackerNews(10)
    @panel = atom.workspace.addTopPanel item: this

    @hackerNews.getTopStories (data, len) =>
      @startNewsLine(data, len)

  startNewsLine: (data, len) ->
    @news = data.top
    @currentNewsIndex = 0
    @newsLength = len

    @showNews "<a href='#{@news[@currentNewsIndex]?.url}'>#{@news[@currentNewsIndex].title}</a>"

    @newsInterval = setInterval =>
      if @currentNewsIndex < @newsLength - 1
        @currentNewsIndex += 1
      else
        @currentNewsIndex = 0

      @showNews "<a href='#{@news[@currentNewsIndex]?.url}'>#{@news[@currentNewsIndex].title}</a>"
    , atom.config.get 'news-line.newsInterval'

  updateNews: ->
    clearInterval @newsInterval
    @hackerNews.getTopStories (data, len) =>
      @startNewsLine(data, len)

  @content: ->
    @div class: 'news-line', =>
      @div class: 'site-name', click: 'toggleSiteList', =>
        @span 'Hacker News'
      @div class: 'site-list', outlet: 'siteList', =>
        @div class: 'site-name', =>
          @span 'aaaaaaaaaaaa'
        @div class: 'site-name', =>
          @span 'bBbbbbbb'
        @div class: 'site-name', =>
          @span 'cccccccc'
      @div class: 'news-container', outlet: 'newsBody'

  showNews: (news) ->
    if $('span.news-body')?
      $('span.news-body').addClass 'news-out'
      setTimeout =>
        $('span.news-body.news-out').remove()
        @newsBody.append "<span class='news-body news-in'>#{news}</span>"
      , 1000

  toggleSiteList: ->
    @siteList.toggleClass 'show'

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

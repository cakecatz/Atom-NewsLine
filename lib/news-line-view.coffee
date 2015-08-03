{CompositeDisposable} = require 'atom'
{View, $} = require 'space-pen'
HackerNews = require './hacker-news'

module.exports =
class NewsLineView extends View
  news: []
  newsSites: []
  newsInterval: null

  initialize: ->
    hackerNews = new HackerNews(atom.config.get('news-line.newsNumber'))
    @panel = atom.workspace.addTopPanel item: this

    @registerSite hackerNews

    @refresh()

    @start()

  loadSiteList: (sites) ->

  refresh: ->
    #TODO: need diff
    @siteList.empty()
    elem = ''
    for site in @newsSites
      @selectedSite.append "<span>#{site.name}</span>"
      elem += "<div class='site-name'><span>#{site.name}</span></div>"

    @siteList.append elem

    @newsSites[0].subscribe this

  registerSite: (site) ->
    @newsSites.push site

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
    @newsSites[0].update()

  @content: ->
    @div class: 'news-line', =>
      @div class: 'site-name', click: 'toggleSiteList', outlet: 'selectedSite'
      @div class: 'site-list', outlet: 'siteList', =>
        @div class: 'site-name', =>
          @span 'Echo JS'
        @div class: 'site-name', =>
          @span 'Front-end Front'
        @div class: 'site-name', =>
          @span 'GitHub Trending'
      @div class: 'news-container', outlet: 'newsBody'

  showNews: (news) ->
    newsElem = "<a href='#{news?.url}'>#{news.title}</a>"

    if $('span.news-body')?
      $('span.news-body').addClass 'news-out'
      setTimeout =>
        $('span.news-body.news-out').remove()
        @newsBody.append "<span class='news-body news-in'>#{newsElem}</span>"
      , 1000

  toggleSiteList: ->
    @siteList.toggleClass 'show'

  start: ->


  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

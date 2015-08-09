{CompositeDisposable} = require 'atom'
{View, $} = require 'space-pen'
HackerNews = require './hacker-news'
EchoJS     = require './echo-js'

module.exports =
class NewsLineView extends View
  news: []
  newsSites: []
  newsInterval: null
  currentActiveSite: null

  initialize: ->
    hackerNews = new HackerNews(atom.config.get('news-line.newsNumber'))
    echoJS     = new EchoJS()

    @panel = atom.workspace.addTopPanel item: this
    @subscriptions = new CompositeDisposable

    @newsInterval = atom.config.get 'news-line.newsInterval'

    @registerSite hackerNews
    @registerSite echoJS

    @currentActiveSite = @newsSites[0]

    @start()

    ## commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'news-line:update-news', =>
      @newsSites[0].update()

  start: ->
    # #TODO:0 need diff
    @siteListElement.empty()
    elem = ''
    for site in @newsSites
      if site.__id is @currentActiveSite.__id
        @selectedSite.empty()
        @selectedSite.append "<span>#{site.name}</span>"
        continue
      elem += "<div class='site-name' data-id='#{site.__id}' ><span>#{site.name}</span></div>"
    @siteListElement.append elem

    $('.site-list .site-name').on 'click', @willChangeActiveSite
    @currentActiveSite.subscribe this

  registerSite: (site) ->
    site.__id = @getId()
    @newsSites.push site

  updateNews: ->
    @currentActiveSite.update()

  willChangeActiveSite: (e) =>
    @toggleSiteList()
    if e.currentTarget.dataset.id isnt @currentActiveSite.__id
      $('.site-list .site-name').off 'click'
      @currentActiveSite?.unsubscribe()
      @currentActiveSite = @getSiteById e.currentTarget.dataset.id
      @start()

  @content: ->
    @div class: 'news-line', =>
      @div class: 'site-name', click: 'toggleSiteList', outlet: 'selectedSite'
      @div class: 'site-list', outlet: 'siteListElement'
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
    @siteListElement.toggleClass 'show'

  getSiteById: (id) ->
    for site in @newsSites
      if site.__id is parseInt(id)
        return site

    return null

  getId: ->
    if @_id?
      @_id += 1
    else
      @_id = 1

    return @_id

  serialize: ->

  destroy: ->
    @element.remove()

  getElement: ->
    @element

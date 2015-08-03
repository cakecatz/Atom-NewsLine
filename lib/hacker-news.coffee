fetch = require 'node-fetch'
p = console.log

module.exports =
class HackerNews
  API_BASE_URL: 'https://hacker-news.firebaseio.com/'
  API_VERSION: 'v0'
  API_URL: null
  newsNumber: 0
  interval: 5000
  newsIndex: 0
  name: 'Hacker News'
  newsList: []
  newsRank: {}

  constructor: (num) ->
    @newsNumber = num
    @API_URL = "#{@API_BASE_URL}#{@API_VERSION}"

  getTopStories: (callback) ->
    fetch "#{@API_URL}/topstories.json"
      .then (res) ->
        res.json()
      .then (data) =>
        @fetchDetailFromIds 'top', data, callback, @newsNumber

  getNewStories: (callback) ->
    fetch "#{@API_URL}/newstories.json"
      .then (res) ->
        res.json()
      .then (ids) =>
        @fetchDetailFromIds 'new', ids, callback, @newsNumber

  fetchDetailFromIds: (type, ids, callback, num=5) ->
    @counter = num
    for index in [0...num]
      newsId = ids[index]
      @newsRank[newsId] = index
      fetch "#{@API_URL}/item/#{newsId}.json"
        .then (res) ->
          res.json()
        .then (data) =>
          @storeNews(index, data)
          @counter -= 1
          @doneFetch(callback) if @counter is 0

  storeNews: (rank, data) ->
    @newsList.push data

  subscribe: (@newsLine) ->
    @getTopStories =>
      @newsLine.showNews @newsList[@newsIndex]
      @newsIndex += 1

      @process = setInterval =>
        @newsLine.showNews @newsList[@newsIndex]
        if @newsIndex < @newsNumber - 1
          @newsIndex += 1
        else
          @newsIndex = 0
      , @interval

  doneFetch: (callback) ->
    @newsList.sort (a, b) =>
      return -1 if @newsRank[a.id] < @newsRank[b.id]
      return 1 if @newsRank[a.id] > @newsRank[b.id]
      return 0

    callback()

  update: ->
    


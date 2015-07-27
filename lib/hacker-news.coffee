fetch = require 'node-fetch'
p = console.log

module.exports =
class HackerNews
  API_BASE_URL: 'https://hacker-news.firebaseio.com/'
  API_VERSION: 'v0'
  API_URL: null
  newsNumber: 0
  news: {}

  constructor: (num) ->
    @newsNumber = num
    @API_URL = "#{@API_BASE_URL}#{@API_VERSION}"

  getTopStories: (cb) ->
    fetch "#{@API_URL}/topstories.json"
      .then (res) ->
        res.json()
      .then (data) =>
        @fetchDetailFromIds 'top', data, cb, @newsNumber

  getNewStories: (cb) ->
    fetch "#{@API_URL}/newstories.json"
      .then (res) ->
        res.json()
      .then (data) =>
        @fetchDetailFromIds 'new', data, cb, @newsNumber

  fetchDetailFromIds: (type, ids, callback, num=5) ->
    @news[type] = [] unless @news[type]
    counter = num
    for index in [0...num]
      @news[type][index] = ids[index]
      fetch "#{@API_URL}/item/#{ids[index]}.json"
        .then (res) ->
          res.json()
        .then (data) =>
          @addNews(type, data)
          counter -= 1
          if counter is 0
            callback(@news, num)

  addNews: (type, data) ->
    for index of @news[type]
      if @news[type][index] is data.id
        @news[type][index] = data


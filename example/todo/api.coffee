# todo api

express = require 'express'
bodyParser = require 'body-parser'

module.exports = ->
  api = express()
  api.use bodyParser.json()

  nextId = 0
  getId = ->
    res = nextId
    nextId += 1
    res

  todos = []

  api.get '/todos', (req, res) ->
    req.profiler.stepSync 'todos index', ->
      res.send todos

  api.post '/todos', (req, res) ->
    req.profiler.stepSync 'todo create', ->
      todo = req.body
      todo.id = getId()
      todos.push todo
      res.redirect 302, "/api/todos/#{todo.id}"

  api.get '/todos/:id', (req, res) ->
    req.profiler.stepSync 'todo read', (p) ->
      result = no
      find = p.step 'find'
      for todo in todos when todo.id is +req.params.id
        return res.send 500 if result
        result = todo
      return res.send 404 unless result
      find.end()
      p.stepSync 'send', -> res.send result

  api.put '/todos/:id', (req, res) ->
    req.profiler.stepSync 'todo update', ->
      result = no
      for todo in todos when todo.id is +req.params.id
        return res.send 500 if result
        result = todo
      return res.send 404 unless result
      for key, prop of req.body when key isnt 'id'
        result[key] = prop
      res.send 200

  api.delete '/todos/:id', (req, res) ->
    req.profiler.stepSync 'todo delete', ->
      result = no
      for i, todo of todos when todo.id is +req.params.id
        return res.send 500 if result
        result = i
      return res.send 404 unless result
      todos.splice result, 1
      res.send 200

  api

# connect resource middleware

{parse} = require 'url'
pathMatch = require 'path-match'

match = pathMatch
  sensitive: no
  strict: yes
  end: yes

route = (path, fn) ->
  match: match path
  handle: fn

module.exports = (tp, opts) ->
  routes = [
    route '/:id', (req, res, params) ->
      result = tp.getById params.id
      return res.send 404 unless result
      res.send 200, result
  ]

  (req, res, next) ->
    path = parse(req.url).pathname
    for r in routes
      params = r.match req.path
      return r.handle req, res, params if params

    next()

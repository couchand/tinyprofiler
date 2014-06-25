# tinyprofiler

middleware = require './middleware'
RequestProfiler = require './request-profiler'

class TinyProfiler
  constructor: (@options) ->
    @_requests = []

  request: (req) ->
    r = new RequestProfiler req, @options
    @_requests.push r
    r

  getById: (id) ->
    for r in @_requests when id is r.getId()
      return r
    return null

  getRequests: ->
    (request.toJSON() for request in @_requests)

  profilingMiddleware: ->
    middleware.profiling this, @options

module.exports = TinyProfiler

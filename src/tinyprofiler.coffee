# tinyprofiler

{EventEmitter} = require 'events'

middleware = require './middleware'
RequestProfiler = require './request-profiler'

class TinyProfiler extends EventEmitter
  constructor: (@options) ->
    @_requests = []

  request: (req) ->
    r = new RequestProfiler req, @options
    @_requests.push r
    @emit 'request', r

    progress = => @emit 'update', r
    complete = => @emit 'complete', r

    attachHandlers = (s) ->
      s.on 'step', (t) ->
        progress()
        attachHandlers t
      s.on 'end', progress

    r.on 'step', (s) ->
      progress()
      attachHandlers s
    r.on 'end', complete

    r

  getById: (id) ->
    for r in @_requests when id is r.getId()
      return r
    return null

  getRequests: ->
    (request.toJSON() for request in @_requests)

  profilingMiddleware: ->
    middleware.profiling this, @options

  resourceMiddleware: ->
    middleware.resource this, @options

module.exports = TinyProfiler

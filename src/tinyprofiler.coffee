# tinyprofiler

{EventEmitter2} = require 'eventemitter2'

middleware = require './middleware'
RequestProfiler = require './request-profiler'

class TinyProfiler extends EventEmitter2
  constructor: (@options) ->
    @_requests = {}

  _attachHandlers: (req) ->
    progress = => @emit 'update', req
    complete = => @emit 'complete', req

    attach = (s) ->
      progress()
      s.on 'step', attach
      s.on 'end', progress

    req.on 'step', attach
    req.on 'end', complete

  request: (req) ->
    r = new RequestProfiler req, @options
    @_requests[r.getId()] = r
    @_attachHandlers r

    @emit 'request', r
    r

  getIds: ->
    Object.keys @_requests

  getById: (id) ->
    return null unless id of @_requests

    r = @_requests[id]
    delete @_requests[id]
    r

  getRequests: ->
    (request.toJSON() for id, request of @_requests)

module.exports = TinyProfiler

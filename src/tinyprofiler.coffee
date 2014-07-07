# tinyprofiler

{EventEmitter2} = require 'eventemitter2'

middleware = require './middleware'
RequestProfiler = require './request-profiler'

class TinyProfiler extends EventEmitter2
  constructor: (@options) ->
    @_requests = []

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
    @_requests.push r
    @_attachHandlers r

    @emit 'request' ,r
    r

  getById: (id) ->
    for r in @_requests when id is r.getId()
      return r
    return null

  getRequests: ->
    (request.toJSON() for request in @_requests)

module.exports = TinyProfiler

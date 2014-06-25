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

  getRequests: ->
    (request.toJSON() for request in @_requests)

  middleware: ->
    middleware this, @options

module.exports = TinyProfiler

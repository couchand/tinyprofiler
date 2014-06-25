# tinyprofiler

middleware = require './middleware'
Profiler = require './profiler'
RequestProfiler = require './request-profiler'

class TinyProfiler
  constructor: ->
    @_requests = []

  request: (req) ->
    r = new RequestProfiler req
    @_requests.push r
    r

  getRequests: ->
    (request.toJSON() for request in @_requests)

  middleware: ->
    middleware this, @options

tinyprofiler = -> new TinyProfiler

tinyprofiler.RequestProfiler = RequestProfiler
tinyprofiler.Profiler = Profiler

module.exports = tinyprofiler

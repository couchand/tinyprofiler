# tinyprofiler

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
    @_requests.map (request) ->
      request.toJSON()

  middleware: (req, res, next) =>
    req.profiler = @request req
    next()
    req.profiler.end()

tinyprofiler = -> new TinyProfiler

tinyprofiler.RequestProfiler = RequestProfiler
tinyprofiler.Profiler = Profiler

module.exports = tinyprofiler

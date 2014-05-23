# tinyprofiler

diff = now = process.hrtime or require 'browser-process-hrtime'

class TinyProfiler
  constructor: ->
    @_requests = []

  request: (req) ->
    r = new RequestProfiler req
    @_requests.push r
    r

  getRequests: ->
    @_requests.map (request) ->
      request.getCalls()

  middleware: (req, res, next) =>
    req.profiler = @request req
    next()
    req.profiler.complete()

class RequestProfiler
  constructor: (req) ->
    @_begin = new Date()
    @_start = now()
    @_profile = {}

  complete: ->
    @_complete = diff @_start

  execSync: (name, fn) ->
    times = _start: diff @_start
    fn()
    times._stop = diff @_start

    @_profile[name] ?= []
    @_profile[name] = @_profile[name].concat [times]

  execAsync: (name, fn) ->
    times = _start: diff @_start
    setTimeout =>
      fn =>
        times._stop = diff @_start

        @_profile[name] ?= []
        @_profile[name] = @_profile[name].concat [times]

  getProfile: (name) ->
    if name
      @_profile[name] or []
    else
      []

  getCalls: ->
    calls = {}
    for name, counts of @_profile
      calls[name] = counts.slice()
    calls._requestBegin = @_begin.toISOString()
    calls._requestComplete = @_complete
    calls

tinyprofiler = -> new TinyProfiler

tinyprofiler.RequestProfiler = RequestProfiler

module.exports = tinyprofiler

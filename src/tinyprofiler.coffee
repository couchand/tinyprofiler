# tinyprofiler

class TinyProfiler
  constructor: ->

  request: (req) ->
    new RequestProfiler req

class RequestProfiler
  constructor: (@req) ->
    @_profile = {}

  execSync: (name, fn) ->
    times = start: new Date()
    fn()
    times.stop = new Date()

    @_profile[name] ?= []
    @_profile[name] = @_profile[name].concat [times]

  execAsync: (name, fn) ->
    times = start: new Date()
    setTimeout =>
      fn =>
        times.stop = new Date()

        @_profile[name] ?= []
        @_profile[name] = @_profile[name].concat [times]

  getProfile: (name) ->
    if name
      @_profile[name] or []
    else
      []

tinyprofiler = -> new TinyProfiler

tinyprofiler.RequestProfiler = RequestProfiler

module.exports = tinyprofiler

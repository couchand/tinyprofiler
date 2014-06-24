# tinyprofiler

diff = now = process.hrtime or require 'browser-process-hrtime'
guid = require './guid'

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

class Profiler
  constructor: (parent_baseline, @_name, @_details) ->
    @_baseline = now()
    @_steps = []
    @_start = diff parent_baseline or @_baseline

  end: ->
    @_stop = diff @_baseline

  step: (name, details, cb) ->
    if typeof name is 'function'
      cb = name
      name = details
      details = null
    else if typeof details is 'function'
      cb = details
      details = null

    step = new Profiler @_baseline, name, details
    @_steps.push step
    cb step if cb
    step

  stepSync: ->
    step = @step.apply this, arguments
    step.end()

  steps: ->
    @_steps.slice()

  toJSON: ->
    me =
      name: @_name
      start: @_start
    me.details = @_details if @_details
    me.end = @_stop if @_stop
    if @_steps.length
      me.steps = @_steps.map (step) -> step.toJSON()
    me

class RequestProfiler extends Profiler
  constructor: (req) ->
    @_id = guid()
    @_begin = new Date()
    super null, "#{req.method} #{req.path}"

  toJSON: ->
    me = super()
    me.id = @_id
    me.start = @_begin.toISOString()
    me

tinyprofiler = -> new TinyProfiler

tinyprofiler.RequestProfiler = RequestProfiler
tinyprofiler.Profiler = Profiler

module.exports = tinyprofiler

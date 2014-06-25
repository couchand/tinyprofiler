# base profiler
#   doesn't like to be explicitly constructed

{EventEmitter} = require 'events'

{diff, now} = require './time'

class Profiler extends EventEmitter
  constructor: (parent_baseline, @_name, @_details) ->
    @_baseline = now()
    @_steps = []
    @_start = diff parent_baseline or @_baseline

  end: ->
    @_length = diff @_baseline
    @emit 'end'

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
    @emit "step", step
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
    me.length = @_length if @_length
    if @_steps.length
      me.steps = (step.toJSON() for step in @_steps)
    me

module.exports = Profiler

# base profiler
#   doesn't like to be explicitly constructed

{diff, now} = require './time'

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
      me.steps = (step.toJSON() for step in @_steps)
    me

module.exports = Profiler

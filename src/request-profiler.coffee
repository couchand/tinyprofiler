# request profiler

{diff, now} = require './time'
guid = require './guid'
Profiler = require './profiler'

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

module.exports = RequestProfiler

# request profiler

xtend = require 'xtend'

{diff, now} = require './time'
guid = require './guid'
Profiler = require './profiler'

defaults =
  requestName: unless window?
    (req) -> "#{req.method} #{req.path}"
  else
    (req) -> "AJAX #{req.path}"
  requestDetails: ->

class RequestProfiler extends Profiler
  constructor: (req, opts) ->
    @_id = guid()
    @_begin = new Date()

    options = xtend {}, defaults, opts
    name = options.requestName req
    details = options.requestDetails req

    super null, name, details

  getId: ->
    @_id

  toJSON: ->
    me = super()
    me.id = @_id
    me.start = @_begin.toISOString()
    me

module.exports = RequestProfiler

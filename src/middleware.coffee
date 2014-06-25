# connect middleware

onHeaders = require 'on-headers'
xtend = require 'xtend'

RequestProfiler = require './request-profiler'

defaults =
  headerName: "X-TinyProfiler-Ids"
  profilerKey: "profiler"
  profileResponse: yes

module.exports = (tp, opts)->
  options = xtend {}, defaults, opts

  (req, res, next) ->
    profiler = req[options.profilerKey] = tp.request req

    responseStep = no
    onHeaders res, ->
      return if @getHeader options.headerName
      @setHeader options.headerName, "[#{profiler.getId()}]"

      return unless options.profileResponse
      responseStep = profiler.step "Response"

    next()

    responseStep.end() if responseStep
    profiler.end() if profiler

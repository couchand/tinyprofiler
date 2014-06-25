# tinyprofiler

Profiler = require './profiler'
RequestProfiler = require './request-profiler'
TinyProfiler = require './tinyprofiler'

module.exports = tinyprofiler = (opts) -> new TinyProfiler opts

tinyprofiler.RequestProfiler = RequestProfiler
tinyprofiler.Profiler = Profiler

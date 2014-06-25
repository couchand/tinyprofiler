# tinyprofiler tests

require '../helper'

tinyprofiler = require '../../src'

describe 'tinyprofiler', ->
  profiler = beforeEach -> profiler = tinyprofiler()

  it 'creates a new RequestProfiler', ->
    req = profiler.request {}
    req.should.be.an.instanceof tinyprofiler.RequestProfiler

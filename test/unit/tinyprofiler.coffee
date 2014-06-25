# tinyprofiler tests

require '../helper'

tinyprofiler = require '../../src'

describe 'tinyprofiler', ->
  profiler = beforeEach -> profiler = tinyprofiler()

  describe 'request', ->
    it 'creates a new RequestProfiler', ->
      req = profiler.request {}
      req.should.be.an.instanceof tinyprofiler.RequestProfiler

  describe 'getById', ->
    it 'gets a RequestProfiler by id', ->
      req = profiler.request {}

      result = profiler.getById req.getId()

      result.should.equal req

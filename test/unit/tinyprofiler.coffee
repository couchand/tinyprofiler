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

  describe 'events', ->
    it 'emits "request" on request', ->
      emitted = no
      profiler.once 'request', (req) ->
        emitted = req

      request = profiler.request {}

      emitted.should.equal request

    it 'emits "complete" when request ends', ->
      emitted = no
      profiler.once 'complete', (req) ->
        emitted = req

      request = profiler.request {}
      emitted.should.be.false

      request.end()
      emitted.should.equal request

    it 'emits "update" on child steps', ->
      emitted = no
      profiler.once 'update', (req) ->
        emitted = req

      request = profiler.request {}
      emitted.should.be.false

      request.step()
      emitted.should.equal request

    it 'emits "update" on child step end', ->
      emitted = 0
      profiler.on 'update', ->
        emitted += 1

      request = profiler.request {}
      emitted.should.equal 0

      step = request.step()
      emitted.should.equal 1

      child = step.step()
      emitted.should.equal 2

      child.end()
      emitted.should.equal 3

      step.end()
      emitted.should.equal 4

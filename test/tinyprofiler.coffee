# tinyprofiler tests

chai = require 'chai'
chai.should()

tinyprofiler = require '../src/tinyprofiler'

describe 'tinyprofiler', ->
  profiler = beforeEach -> profiler = tinyprofiler()

  describe 'request', ->
    req = beforeEach -> req = profiler.request {}

    it 'creates a new RequestProfiler', ->
      req.should.be.an.instanceof tinyprofiler.RequestProfiler

    describe 'execSync', ->
      it 'calls the function synchronously', ->
        called = no
        req.execSync 'foobar', -> called = yes
        called.should.be.true
        foobarCalls = req.getProfile 'foobar'
        foobarCalls.length.should.equal 1
        foobarCalls[0].start.should.exist
        foobarCalls[0].stop.should.exist

    describe 'execAsync', ->
      it 'calls the function asynchronously', ->
        called = no
        req.execAsync 'foobar', (done) ->
          called = yes
          done()
          foobarCalls = req.getProfile 'foobar'
          foobarCalls.length.should.equal 1
          foobarCalls[0].start.should.exist
          foobarCalls[0].stop.should.exist
        called.should.be.false

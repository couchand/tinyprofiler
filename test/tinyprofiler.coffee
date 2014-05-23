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
        start = new Date
        middle = no
        req.execSync 'foobar', ->
          called = yes
          middle = new Date
        stop = new Date

        called.should.be.true

        foobarCalls = req.getProfile 'foobar'
        foobarCalls.length.should.equal 1
        call = foobarCalls[0]

        call.start.should.be.least start
        call.start.should.be.most middle
        call.stop.should.be.least middle
        call.stop.should.be.most stop
        call.start.should.be.most stop

    describe 'execAsync', ->
      it 'calls the function asynchronously', ->
        called = no
        start = new Date
        req.execAsync 'foobar', (done) ->
          called = yes
          done()
          stop = new Date

          foobarCalls = req.getProfile 'foobar'
          foobarCalls.length.should.equal 1
          call = foobarCalls[0]

          call.start.should.be.least start
          call.start.should.be.most middle
          call.stop.should.be.least middle
          call.stop.should.be.most stop
          call.start.should.be.most stop

        called.should.be.false
        middle = new Date

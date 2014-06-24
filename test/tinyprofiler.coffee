# tinyprofiler tests

chai = require 'chai'
chai.should()

# patch assertions for hrtime
originalLeast = chai.Assertion.prototype.least
originalMost = chai.Assertion.prototype.most
chai.Assertion.prototype.least = (you) ->
  unless @_obj.length is 2 and you.length is 2
    return originalLeast.call this, you
  me = @_obj
  if me[0] is you[0]
    me[1].should.be.at.least you[1]
  else
    me[0].should.be.at.least you[0]
chai.Assertion.prototype.most = (you) ->
  unless @_obj.length is 2 and you.length is 2
    return originalMost.call this, you
  me = @_obj
  if me[0] is you[0]
    me[1].should.be.at.most you[1]
  else
    me[0].should.be.at.most you[0]

tinyprofiler = require '../src/tinyprofiler'

describe 'tinyprofiler', ->
  profiler = beforeEach -> profiler = tinyprofiler()

  describe 'request', ->
    it 'creates a new RequestProfiler', ->
      req = profiler.request {}
      req.should.be.an.instanceof tinyprofiler.RequestProfiler

    describe 'execSync', ->
      it 'times the function synchronously', ->
        req = profiler.request {}
        start = process.hrtime()
        req.execSync 'foobar', ->
        stop = process.hrtime start

        foobarCalls = req.getProfile 'foobar'
        foobarCalls.length.should.equal 1
        call = foobarCalls[0]

        call._start.should.be.at.least [0,0]
        call._stop.should.be.at.most stop
        call._start.should.be.at.most call._stop

    describe 'execAsync', ->
      it 'times the function asynchronously', ->
        req = profiler.request {}
        start = process.hrtime()
        req.execAsync 'foobar', (done) ->
          done()
          stop = process.hrtime()

          foobarCalls = req.getProfile 'foobar'
          foobarCalls.length.should.equal 1
          call = foobarCalls[0]

          call._start.should.be.at.least [0, 0]
          call._stop.should.be.at.most stop
          call._start.should.be.at.most call._stop

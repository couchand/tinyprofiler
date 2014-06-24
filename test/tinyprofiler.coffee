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

chai.Assertion.prototype.exactly = (you) ->
  me = @_obj
  unless me.length is 2 and you.length is 2
    throw new Error "exactly only accepts hrtime tuples"
  me[0].should.equal you[0]
  me[1].should.equal you[1]

tinyprofiler = require '../src/tinyprofiler'

describe 'tinyprofiler', ->
  profiler = beforeEach -> profiler = tinyprofiler()

  it 'creates a new RequestProfiler', ->
    req = profiler.request {}
    req.should.be.an.instanceof tinyprofiler.RequestProfiler

describe 'Profiler', ->
  describe '_baseline', ->
    it 'is set in the constructor', ->
      start = process.hrtime()
      profile = new tinyprofiler.Profiler()
      stop = process.hrtime()

      profile._baseline.should.be.at.least start
      profile._baseline.should.be.at.most stop

  describe '_start', ->
    it 'is the time from parent_start to _baseline', ->
      parent_start = process.hrtime()
      i * j for i in [0..100] for j in [0..100]
      start = process.hrtime parent_start
      profile = new tinyprofiler.Profiler parent_start
      stop = process.hrtime parent_start

      profile._start.should.be.at.least start
      profile._start.should.be.at.most stop

    it 'defaults to own baseline', ->
      profile = new tinyprofiler.Profiler()
      stop = process.hrtime profile._baseline

      profile._start.should.be.at.most stop

  describe 'end', ->
    it 'sets _stop', ->
      profile = new tinyprofiler.Profiler()

      start = process.hrtime profile._baseline
      profile.end()
      stop = process.hrtime profile._baseline

      profile._stop.should.be.at.least start
      profile._stop.should.be.at.most stop

  describe 'step', ->
    it 'returns a Profiler', ->
      parent = new tinyprofiler.Profiler()

      child = parent.step()

      child.should.be.an.instanceOf tinyprofiler.Profiler

    it 'returns a child of itself', ->
      parent = new tinyprofiler.Profiler()

      start = process.hrtime parent._baseline
      child = parent.step()
      stop = process.hrtime parent._baseline

      parent.steps().should.contain child
      child._start.should.be.at.least start
      child._start.should.be.at.most stop

    it 'calls back with the child', ->
      parent = new tinyprofiler.Profiler()

      start = process.hrtime parent._baseline
      parent.step (child) ->
        stop = process.hrtime parent._baseline

        parent.steps().should.contain child
        child._start.should.be.at.least start
        child._start.should.be.at.most stop

    it 'takes a name', ->
      profile = new tinyprofiler.Profiler()

      child = profile.step 'Foobar'

      child._name.should.equal 'Foobar'

    it 'takes optional details', ->
      profile = new tinyprofiler.Profiler()

      child = profile.step 'Foobar', 'Baz'

      child._details.should.equal 'Baz'

    it 'takes optional callback', ->
      profile = new tinyprofiler.Profiler()

      profile.step 'Foobar', (child) ->
        child._name.should.equal 'Foobar'

  describe 'toJSON', ->
    it 'returns the tinyprofiler data structure', ->
      profile = new tinyprofiler.Profiler()

      profile.step 'Foobar'

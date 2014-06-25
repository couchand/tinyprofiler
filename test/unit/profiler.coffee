# profiler tests

require '../helper'

tinyprofiler = require '../../src/tinyprofiler'

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
      step = profile.step 'Foobar'
      step.end()
      profile.end()

      json = profile.toJSON()

      json.should.have.property 'start'
      json.should.have.property 'end'
      json.should.have.property 'steps'
      json.steps.length.should.equal 1

      json.steps[0].should.have.property 'name'
      json.steps[0].should.have.property 'start'
      json.steps[0].should.have.property 'end'

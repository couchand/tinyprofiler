# RequestProfiler tests

helper = require '../helper'

tinyprofiler = require '../../src'

describe 'RequestProfiler', ->
  describe 'getId', ->
    it 'returns a guid', ->
      profiler = new tinyprofiler.RequestProfiler {}

      id = profiler.getId()

      id.should.have.length 16

  describe 'toJSON', ->
    it 'has an id', ->
      profiler = new tinyprofiler.RequestProfiler {}

      json = profiler.toJSON()

      json.should.have.property 'id'
      json.id.should.have.length 16

    it 'has a start date', ->
      profiler = new tinyprofiler.RequestProfiler {}

      json = profiler.toJSON()

      json.should.have.property 'start'
      json.start.should.have.length 24 # only true for 7986 more years

# integration tests

chai = require 'chai'
chai.should()

express = require 'express'
request = require 'superagent'
http = require 'http'

tinyprofiler = require '../src'
middleware = require '../src/middleware'

describe "a sync profiled request", ->
  options = profileResponse: no
  profiler = beforeEach -> profiler = tinyprofiler options

  it "stores the profile", ->
    app = express()
    app.use '/tp', middleware.resource profiler, options
    app.use middleware.profiling profiler, options
    app.get '/', (req, res) ->
      req.profiler.stepSync 'root', (step) ->
        step.stepSync 'send', ->
          res.send 'foobar'
    server = http.createServer app
      .listen 77637

    start = new Date().toISOString()
    request 'http://localhost:77637', (res) ->
      finish = new Date().toISOString()

      ids = JSON.parse res.headers["x-tinyprofiler-ids"]
      ids.length.should.equal 1
      id = ids[0]

      request 'http://localhost:77637', (res) ->
        ids = JSON.parse res.headers["x-tinyprofiler-ids"]
        ids.length.should.equal 2

      request "http://localhost:77637/tp/#{id}", (res) ->
        server.close()

        request = res.body

        request.should.have.property 'name'
        request.name.should.match /^GET/
        request.should.have.property 'start'
        request.should.have.property 'length'

        request.should.have.property 'steps'
        request.steps.length.should.equal 1
        root = request.steps[0]

        root.should.have.property 'name'
        root.name.should.equal 'root'
        root.should.have.property 'start'
        root.should.have.property 'length'

        root.should.have.property 'steps'
        root.steps.length.should.equal 1
        send = root.steps[0]

        send.should.have.property 'name'
        send.name.should.equal 'send'
        send.should.have.property 'start'
        send.should.have.property 'length'

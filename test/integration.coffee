# integration tests

chai = require 'chai'
chai.should()

express = require 'express'
request = require 'superagent'
http = require 'http'

tinyprofiler = require '../src'

describe "a sync profiled request", ->
  profiler = beforeEach -> profiler = tinyprofiler profileResponse: no

  it "stores the profile", ->
    app = express()
    app.use '/tp', profiler.resourceMiddleware()
    app.use profiler.profilingMiddleware()
    app.get '/', (req, res) ->
      req.profiler.stepSync 'root', (step) ->
        step.stepSync 'send', ->
          res.send 'foobar'
    server = http.createServer app
      .listen 77637

    start = new Date().toISOString()
    request 'http://localhost:77637', (res) ->
      finish = new Date().toISOString()

      id = JSON.parse res.headers["x-tinyprofiler-ids"]

      request "http://localhost:77637/tp/#{id[0]}", (res) ->
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

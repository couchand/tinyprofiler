# integration tests

chai = require 'chai'
chai.should()

express = require 'express'
http = require 'http'

tinyprofiler = require '../src/tinyprofiler'

describe "a sync profiled request", ->
  profiler = beforeEach -> profiler = tinyprofiler()

  it "stores the profile", ->
    app = express()
    app.use profiler.middleware
    app.get '/', (req, res) ->
      req.profiler.execSync 'root', ->
        req.profiler.execSync 'send', ->
          res.send 'foobar'
    server = http.createServer app
      .listen 77637

    start = new Date().toISOString()
    http.get 'http://localhost:77637', (res) ->
      res.on 'data', ->
      res.on 'end', ->
        finish = new Date().toISOString()
        server.close()

        requests = profiler.getRequests()
        requests.length.should.equal 1
        request = requests[0]

        request.should.have.property 'root'
        request.root.length.should.equal 1
        request.root[0].should.have.property '_start'
        request.root[0].should.have.property '_stop'

        request.should.have.property 'send'
        request.send.length.should.equal 1
        request.send[0].should.have.property '_start'
        request.send[0].should.have.property '_stop'

        request.should.have.property '_requestBegin'
        request._requestBegin.should.be.within start, finish

        request.should.have.property '_requestComplete'

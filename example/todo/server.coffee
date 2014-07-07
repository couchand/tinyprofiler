# to do example app

express = require 'express'
tp = require '../../lib'
middleware = require '../../lib/middleware'

app = require './app'
api = require './api'

server = express()
profiler = tp()

server.use '/tp', middleware.resource profiler
server.use middleware.profiling profiler
server.use app()
server.use '/api', api()

server.listen 1337
console.log "server listening on localhost:1337"

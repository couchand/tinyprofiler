# to do example app

express = require 'express'
tp = require '../../lib'

app = require './app'
api = require './api'

server = express()
profiler = tp()

server.use '/tp', profiler.resourceMiddleware()
server.use profiler.profilingMiddleware()
server.use app()
server.use '/api', api()

server.listen 1337
console.log "server listening on localhost:1337"

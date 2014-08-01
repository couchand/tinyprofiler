# todo app

fs = require 'fs'
express = require 'express'

module.exports = ->
  app = express()

  app.get '/', (req, res) ->
    req.profiler.stepSync 'index', ->
      res.send """
<html>
  <head>
    <title>todo example</title>
    <link rel="stylesheet" href="styles.css"></script>
    <script src="client.js"></script>
  </head>
  <body>
    <h1>todos</h1>
    <ul id="todos"></ul>
    <div id="tp"></div>
  </body>
</html>
"""

  app.get '/styles.css', (req, res) ->
    fs.createReadStream "#{__dirname}/node_modules/tinyprofiler-client/lib/index.css"
      .pipe res

  app.use express.static __dirname

  app

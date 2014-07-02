# todo app

express = require 'express'

module.exports = ->
  app = express()

  app.get '/', (req, res) ->
    req.profiler.stepSync 'index', ->
      res.send """
<html>
  <head>
    <title>todo example</title>
    <script src="client.js"></script>
  </head>
  <body>
    <h1>todos</h1>
    <ul id="todos"></ul>
    <div id="tp"></div>
  </body>
</html>
"""

  app.use express.static __dirname

  app

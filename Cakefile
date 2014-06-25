# build
#   ripped from the coffee-script Cakefile

fs = require 'fs'

{spawn} = require 'child_process'

build = (cb) ->
  console.log "building..."
  files = fs.readdirSync 'src'
  files = ('src/' + file for file in files when file.match(/\.(lit)?coffee$/))
  run ['-c', '-o', 'lib'].concat(files), cb

run = (args, cb) ->
  proc = spawn 'coffee', args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on 'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

task 'build', 'build tinyprofiler', build

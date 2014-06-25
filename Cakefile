# build
#   ripped from the coffee-script Cakefile

fs = require 'fs'

{spawn} = require 'child_process'

dirs = ['src', 'src/middleware']

build = (cb) ->
  console.log "building..."

  left = dirs.length
  check = ->
    cb() if  typeof cb is 'function' and 0 is left -= 1

  buildDir dir, check for dir in dirs

buildDir = (dir, cb) ->
  outdir = "lib" + dir[3..]
  files = fs.readdirSync dir
  coffeefiles = ("#{dir}/#{file}" for file in files when file.match(/\.(lit)?coffee$/))
  run ['-c', '-o', outdir].concat(coffeefiles), cb

run = (args, cb) ->
  proc = spawn 'coffee', args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on 'exit', (status) ->
    process.exit(1) if status != 0
    cb() if typeof cb is 'function'

task 'build', 'build tinyprofiler', build

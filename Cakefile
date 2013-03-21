{exec} = require 'child_process'


task 'test', 'Runs all Jasmine specs in spec/ folder', ->
  test()

task 'compile', 'Compiles coffee in source/ to js in bin/', ->
  compile()

# task 'stitch', 'Stitches all app .js files', ->
#   stitch()

task 'compress', 'Runs UglifyJS on stitched file in order to compress it', ->
  compress()

task 'build', 'Does the full build magic', ->
  # compile -> test -> stitch -> compress()
  compile -> test -> compress()

task 'develop', 'Only compile and stitch, don\'t test or compress', ->
  # compile -> stitch()
  compile()


test = (callback) ->
  console.log "Running Jasmine specs"
  exec 'jasmine-node --noStack --coffee spec/', (err, stdout, stderr) =>
    console.log stdout + stderr

    # hack to work around jasmine-node's bad return vals:
#    throw "Tests fail. Build fails. You fail." if ~stdout.indexOf "Expected"

    callback?()


compile = (callback) ->
  exec 'coffee -o bin/ -c source/', (err, stdout, stderr) ->
    throw err if err
    console.log "Compiled coffee files"
    callback?()


# stitch = (callback) ->
#   stitch = require 'stitch'
#   fs = require 'fs'

#   myPackage = stitch.createPackage paths: [__dirname + '/bin', __dirname + '/vendor']
#   myPackage.compile (err, source) ->
#     fs.writeFile 'app.js', source, (err) ->
#       throw err if err
#       console.log "Stitched js files"
#       callback?()


compress = (callback) ->
  exec 'uglifyjs bin/ra.js -o bin/ra.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log "Compressed ra.js to ra.min.js"
    callback?()

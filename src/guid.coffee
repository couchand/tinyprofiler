# guid generate
# from: <http://stackoverflow.com/questions/6248666/how-to-generate-short-uid-like-ax4j9z-in-js>

length = 4
chunks = 4

chunk = ->
  (('0' for [1..length]).join('') +
    (Math.random() * Math.pow(36, length) << 0).toString 36
  ).slice -length

module.exports = guid = ->
  (chunk() for [1..chunks]).join ''

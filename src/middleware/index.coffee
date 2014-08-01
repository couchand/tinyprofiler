# middlewares

module.exports = require '../'
module.exports.middleware =
  profiling: require './profiling'
  resource: require './resource'

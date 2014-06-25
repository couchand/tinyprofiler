# test helpers

chai = require 'chai'
chai.should()

# patch assertions for hrtime
originalLeast = chai.Assertion.prototype.least
originalMost = chai.Assertion.prototype.most

chai.Assertion.prototype.least = (you) ->
  unless @_obj.length is 2 and you.length is 2
    return originalLeast.call this, you
  me = @_obj
  if me[0] is you[0]
    me[1].should.be.at.least you[1]
  else
    me[0].should.be.at.least you[0]

chai.Assertion.prototype.most = (you) ->
  unless @_obj.length is 2 and you.length is 2
    return originalMost.call this, you
  me = @_obj
  if me[0] is you[0]
    me[1].should.be.at.most you[1]
  else
    me[0].should.be.at.most you[0]

chai.Assertion.prototype.exactly = (you) ->
  me = @_obj
  unless me.length is 2 and you.length is 2
    throw new Error "exactly only accepts hrtime tuples"
  me[0].should.equal you[0]
  me[1].should.equal you[1]

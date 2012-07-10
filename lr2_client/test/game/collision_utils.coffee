World = require 'game/world/world'
Brick = require('game/world/objects').Brick

exports.fakeGame = ->
  getStage: ->
    getWidth: -> 1024
    getHeight: -> 512
  getResource: ->
    null

exports.fakeWorld = (game) ->
  new World game

# spawn bricks at X,Y with dimension 42x42
exports.spawn = (world, x, y) ->
  new Brick world,
    x: x
    y: y
    color: 'blue'

exports.shouldCrash = (expectedWho, expectedDirection, done) ->
  crashed: (who, direction) ->
    expect(who).to.equal expectedWho
    expect(direction).to.equal expectedDirection
    done()

exports.shouldNotCrash =
  crashed: (who, direction) ->
    throw new Error('Should NOT crash', who, direction)

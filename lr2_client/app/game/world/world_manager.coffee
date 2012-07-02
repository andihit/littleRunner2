module.exports = class WorldManager

  constructor: (@world) ->
    
  @level1: ->
    Floor = require './sticky/floor'
    
    [
      [Floor, {x: 0,   y: 400, count: 20}]
      [Floor, {x: 0,   y: 300, count:  2}]
      [Floor, {x: 400, y: 300, count:  3}]
      [Floor, {x: 500, y: 200, count:  3}]
    ]
    
  load: (level, done) ->
    callableElements = level.map (gameObjectDef) ->
      [Class, config] = gameObjectDef
      (done) ->
        go = new Class @world, config, done
        
    async.parallel callableElements, (err, gameObjects) =>
      @world.add(go) for go in gameObjects
      done()

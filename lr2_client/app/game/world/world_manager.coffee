StickyObject = require './sticky/sticky_object'
MovingObject = require './moving/moving_object'

module.exports = class WorldManager

  constructor: (@world) ->
    
  @level1: ->
    Floor = require './sticky/floor'
    
    [
      [Floor, 0, 400, 20]
      [Floor, 0, 300, 2]
      [Floor, 400, 300, 3]
      [Floor, 500, 200, 3]
    ]
    
  load: (level, done) ->
    callableElements = level.map (gameObjectDef) ->
      [Class, params...] = gameObjectDef
      (done) ->
        go = new Class @world
        
        params.push done
        go.init.apply go, params
        
    async.parallel callableElements, (err, gameObjects) =>
      for go in gameObjects
        if go instanceof StickyObject
          @world.stickyObjects.push go
        else if go instanceof MovingObject
          @world.movingObjects.push go
          
        @world.layer.add go.getNode()
      done()

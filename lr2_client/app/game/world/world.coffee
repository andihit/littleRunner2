StickyObject = require './sticky/sticky_object'
MovingObject = require './moving/moving_object'
Viewport = require './viewport'

module.exports = class World
  
  constructor: (width, height, done) ->
    @layer = new Kinetic.Layer id: 'world'
    @viewport = new Viewport width, height
    
    @movingObjects = []
    @stickyObjects = []
    @tux = null
    
    @load done
  
  changeViewport: (x, y) ->
    @viewport.x = x
    @viewport.y = y
    
  applyViewport: (ctx) ->
    ctx.translate -@viewport.x, -@viewport.y
    
  applyReversedViewport: (ctx) ->
    ctx.translate @viewport.x, @viewport.y

  loop: (frame) ->
    go.loop frame for go in @movingObjects
    
    right = (@tux.getRight() + 100) - (@viewport.x + @viewport.width)
    if right > 0
      @viewport.x += right
      @layer.draw()
    
    left = (@tux.getLeft() - 100) - (@viewport.x)
    if left < 0
      @viewport.x += left
      @layer.draw()
      
  level1: ->
    Floor = require './sticky/floor'
    
    [
      [Floor, 0, 400, 20]
      [Floor, 0, 300, 2]
      [Floor, 400, 300, 3]
      [Floor, 500, 200, 3]
    ]
    
  load: (done) ->
    level = @level1()
    
    callableElements = level.map (gameObjectDef) ->
      [Class, params...] = gameObjectDef
      (done) ->
        go = new Class()
        
        params.push done
        go.init.apply go, params
        
    async.parallel callableElements, (err, gameObjects) =>
      for go in gameObjects
        if go instanceof StickyObject
          @stickyObjects.push go
        else if go instanceof MovingObject
          @movingObjects.push go
          
        @layer.add go.getNode()
      done()

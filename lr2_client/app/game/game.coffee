World = require './world/world'
WorldManager = require './world/world_manager'
Tux = require './world/moving/tux'

module.exports = class Game
  
  constructor: (@container) ->
    
  initKeyEvents: ->
    @pressedKeys = {}
  
    $(window).on 'keydown', (e) =>
      return if @pressedKeys[e.keyCode]
      @pressedKeys[e.keyCode] = true
      
    $(window).on 'keyup', (e) =>
      delete @pressedKeys[e.keyCode]
  
  initStage: ->
    @stage = new Kinetic.Stage
      container: @container[0],
      width:     @container.width(),
      height:    @container.height()

  applyViewport: (layer) ->
    layer.beforeDraw @world.applyViewport.bind         @world, layer.getContext()
    layer.afterDraw  @world.applyReversedViewport.bind @world, layer.getContext()
    layer
    
  initWorld: (done) =>
    @world = new World @, @stage.getWidth(), @stage.getHeight()
     
    worldManager = new WorldManager @world
    worldManager.load WorldManager.level1(), =>
      @stage.add @applyViewport layer for layer in [@world.stickyObjects, @world.movingObjects]
      done()
    
  initTux: (done) =>
    @tux = new Tux @world, 100, =>
      layer = new Kinetic.Layer
      layer.add @tux
      
      @stage.add @applyViewport layer
      
      @tux.start()
      @world.tux = @tux
      done()
  
  loop: (frame) =>
    @world.loop frame
    @tux.loop frame, @pressedKeys
    
  start: ->
    @initStage()
    @initKeyEvents()
    
    async.waterfall [
      @initWorld,
      @initTux
    ], =>
      @stage.onFrame @loop
      @stage.start()
      
  stop: ->
    @stage.stop()

World = require './world/world'
WorldManager = require './world/world_manager'
Tux = require './world/moving/tux'
Keys = require './keys'

module.exports = class Game
  
  constructor: (@container) ->
    
  initKeyEvents: ->
    $(window).on 'keydown', Keys.keyDown
    $(window).on 'keyup', Keys.keyUp
  
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

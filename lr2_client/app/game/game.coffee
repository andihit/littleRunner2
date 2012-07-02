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
      container: @container.attr('id'),
      width:     @container.width(),
      height:    @container.height()

  initWorld: (done) =>
    @world = new World @stage.getWidth(), @stage.getHeight()
    @world.layer.beforeDraw @world.applyViewport.bind         @world, @world.layer.getContext()
    @world.layer.afterDraw  @world.applyReversedViewport.bind @world, @world.layer.getContext()
      
    worldManager = new WorldManager @world
    worldManager.load WorldManager.level1(), =>
      @stage.add @world.layer
      done()
    
  initTux: (done) =>
    @tux = new Tux @world, =>
      layer = new Kinetic.Layer id: 'tuxLayer'
      layer.beforeDraw @world.applyViewport.bind         @world, layer.getContext()
      layer.afterDraw  @world.applyReversedViewport.bind @world, layer.getContext()
      
      layer.add @tux.shape
      @stage.add layer
      
      @tux.shape.start()
      @world.tux = @tux
      done()
  
  loop: (frame) =>
    @world.loop frame, @
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

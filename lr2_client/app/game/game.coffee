World = require './world/world'
WorldManager = require './world/world_manager'
Resources = require './resources'
Tux = require './world/moving/tux'
Keys = require './keys'

module.exports = class Game
  
  initStage: (container) ->
    @stage = new Kinetic.Stage
      container: container[0],
      width:     container.width(),
      height:    container.height()
      
  getStage: ->
    @stage

  applyViewport: (layer) ->
    layer.beforeDraw @world.applyViewport.bind         @world, layer.getContext()
    layer.afterDraw  @world.applyReversedViewport.bind @world, layer.getContext()
    layer
    
  initKeyEvents: ->
    $(window).on 'keydown', Keys.keyDown
    $(window).on 'keyup', Keys.keyUp
    
  initResources: (done) ->
    @resources = new Resources
    @resources.load done
    
  getResource: (name) ->
    @resources.get name
    
  initWorld: (level) =>
    @world = new World @
     
    worldManager = new WorldManager @world
    worldManager.load level
    
    @stage.add @applyViewport layer for layer in [@world.stickyObjects, @world.movingObjects]
    
  initTux: =>
    @tux = new Tux @world, {x: 100, y: 100}
    
    layer = new Kinetic.Layer
    layer.add @tux  
    @stage.add @applyViewport layer
      
    @tux.start()
    @world.tux = @tux
  
  loop: (frame) =>
    @world.loop frame
    @tux.loop frame
    
  start: (container) ->
    @initStage container
    @initKeyEvents()
    
    @initResources =>
      @initWorld 'level1.json'
      @initTux()
    
      @stage.onFrame @loop
      @stage.start()
    
  stop: ->
    @stage.stop()

Resources = require './resources'
World = require './world/world'
LevelManager = require './level_manager'
Tux = require('./world/objects').Tux
Keys = require './keys'

module.exports = class Game
  
  constructor: (@container) ->
    
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
    LevelManager.load @world, level
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
    
  start: ->
    @initStage @container
    @initKeyEvents()
    
    @initResources =>
      @initWorld 'level1.json'
      @initTux()
    
      @stage.onFrame @loop
      @stage.start()
    
  stop: ->
    @stage.stop()

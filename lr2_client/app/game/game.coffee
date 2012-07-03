Resources = require './resources'
World = require './world/world'
LevelManager = require './level_manager'
NetworkManager = require './network_manager'
Tux = require './world/objects/moving/tux'
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
    
  initKeyEvents: ->
    @keys = new Keys
    $(window).on 'keydown', @keys.keyDown
    $(window).on 'keyup', @keys.keyUp
    
  initResources: (done) ->
    @resources = new Resources
    @resources.load done
    
  getResource: (name) ->
    @resources.get name
    
  initWorld: (level) =>
    @world = new World @
    LevelManager.load @world, @getResource 'levels/level1.json'
    @stage.add layer for layer in [@world.stickyObjects, @world.movingObjects, @world.playerObjects]
  
  initNetworkManager: ->
    @networkManager = new NetworkManager @world
    
  initTux: =>
    @tux = new Tux @world, {x: 100, y: 100}, @keys
    @world.add @tux
    @world.tux = @tux
    
    @tux.start()
  
  start: ->
    @initStage @container
    @initKeyEvents()
    
    @initResources =>
      @initWorld 'level1.json'
      @initNetworkManager()
      @initTux()
    
      @stage.onFrame @world.loop
      @stage.start()
      
  stop: (message) ->
    @stage.stop()
    @stage.reset()
    @networkManager.dispose()
    alert message

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
    
    $(window).on 'keydown', (e) =>
      return unless Keys.isSupported e.keyCode
      e.preventDefault()
      
      @keys.keyDown e.keyCode
      
    $(window).on 'keyup', (e) =>
      @keys.keyUp e.keyCode
    
  initResources: (done) ->
    @resources = new Resources
    @resources.load done
    
  getResource: (name) ->
    @resources.get name
    
  initWorld: (level) =>
    @world = new World @
    LevelManager.load @world, @getResource 'levels/level1.json'
    @stage.add layer for layer in @world.getAllLayers()
  
  initNetworkManager: ->
    @networkManager = new NetworkManager @world, @keys
    
  initTux: =>
    @tux = new Tux @world, {}, @keys
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
      
      # TODO
      #@networkManager.addPlayer id: 'A', x: 500, y: 100
      #_.delay (=> @networkManager.keyChange id: 'A', down: true, keyCode: 32), 5000
      
  stop: (message) ->
    @stage.stop()
    @stage.reset()
    @networkManager.stop()
    alert message

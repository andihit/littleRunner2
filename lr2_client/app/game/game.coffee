Resources = require './resources'
World = require './world/world'
LevelManager = require './level_manager'
NetworkManager = require './network_manager'
Tux = require './world/objects/moving/tux'
Highscore = require './highscore'
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
    
  initWorld: (level) ->
    @world = new World @
    LevelManager.load @world, @getResource 'levels/level1.json'
    @stage.add layer for layer in @world.getAllLayers()
  
  initNetworkManager: ->
    @networkManager = new NetworkManager @world, @keys
    
  initTux: ->
    @tux = new Tux @world, {}, @keys
    @world.add @tux
    @world.tux = @tux
  
  initHighscore: ->
    @highscore = new Highscore @container.find('#highscore'), @world
  
  getHighscore: ->
    @highscore
  
  changeNickname: (newNick) ->
    @networkManager.changeNickname newNick
    
  start: ->
    @initStage @container.find '#canvasContainer'
    @initKeyEvents()
    
    @initResources =>
      @initWorld 'level1.json'
      @initNetworkManager()
      @initTux()
      @initHighscore()
    
      @stage.onFrame @world.loop
      @stage.start()
  
  stop: (reason) ->
    @stopped = true
    @stage.stop()
    @networkManager.stop()
    @highscore.dispose()
    
    $(window).off 'keydown keyup'
    
    @container.find('#gameOver #reason').text reason
    @container.find('#canvasContainer').css 'opacity', '.4'
    @container.find('#gameOver').css 'display', 'block'

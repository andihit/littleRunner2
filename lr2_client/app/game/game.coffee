Resources = require './resources'
World = require './world/world'
LevelManager = require './level_manager'
NetworkManager = require './network_manager'
Tux = require './world/objects/moving/tux'
HighscoreOverlay = require './ui/highscore_overlay'
LivesOverlay = require './ui/lives_overlay'
Keys = require './ui/keys'

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
    
    # mobile devices
    @stage.on 'tap', =>
      @keys.keyDown 'touch'
      _.defer => @keys.keyUp 'touch'
      
    window.addEventListener 'devicemotion', (e) =>
      y = e.accelerationIncludingGravity.y
      
      if y < -2 # go right
        @keys.keyUp 'tiltLeft'
        @keys.keyDown 'tiltRight'
      else if y > 2 # go left
        @keys.keyUp 'tiltRight'
        @keys.keyDown 'tiltLeft'
    
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
  
  getNetworkManager: ->
    @networkManager
    
  initTux: ->
    @tux = new Tux @world, {}, @keys
    @world.add @tux
    @world.tux = @tux
  
  initOverlays: ->
    @overlays =
      highscore: new HighscoreOverlay @container.find('#highscore'), @world
      lives:     new LivesOverlay     @container.find('#lives'), @world
    
    overlay.update() for name, overlay of @overlays
  
  getOverlay: (name) ->
    @overlays[name]
  
  changeNickname: (newNick) ->
    @networkManager.changeNickname newNick
  
  start: ->
    @initStage @container.find '#canvasContainer'
    @initKeyEvents()
    
    @initResources =>
      @initWorld 'level1.json'
      @initNetworkManager()
      @initTux()
      @initOverlays()
      
      @stage.onFrame @world.loop
      @stage.start()
  
  gameOver: ->
    @isGameOver = true
    @stage.stop()
    @networkManager.stop()
    overlay.dispose?() for name, overlay of @overlays
    
    $(window).off 'keydown keyup'
    
    @container.find('#canvasContainer').css 'opacity', '.4'
    @container.find('#gameOver').css 'display', 'block'

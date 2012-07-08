StickyObject = require './base/sticky_object'
MovingObject = require './base/moving_object'
Tux = require './objects/moving/tux'
Viewport = require './viewport'
Keys = require 'game/keys'

module.exports = class World
  
  constructor: (@game) ->
    @movingObjects = new Kinetic.Layer
    @stickyObjects = new Kinetic.Layer
    @playerObjects = new Kinetic.Layer
    @tux = null
    
    @viewport = new Viewport @game.getStage().getWidth(), @game.getStage().getHeight()
  
  getGame: ->
    @game

  getViewport: ->
    @viewport
    
  getLayer: (go) ->
    if go instanceof StickyObject
      @stickyObjects
    else if go instanceof Tux
      @playerObjects
    else if go instanceof MovingObject
      @movingObjects
  
  getAllLayers: ->
    [@stickyObjects, @movingObjects, @playerObjects]
    
  add: (go) ->
    @getLayer(go).add go
    go.start?()
    
  remove: (go) ->
    @getLayer(go).remove go
  
  updateViewport: ->
    @game.getStage().setOffset -@viewport.x, -@viewport.y
    layer.draw() for layer in @getAllLayers()
  
  sideScrolling: ->
    # tux side scrolling
    if @tux.getLeft() + @viewport.x < 100
      @viewport.x = 100 - @tux.getLeft()
      @updateViewport()
    
    if @tux.getRight() + @viewport.x > @viewport.width - 100
      @viewport.x = @viewport.width - 100 - @tux.getRight()
      @updateViewport()
      
    if @tux.getTop() + @viewport.y < 100 or @viewport.y > 0
      @viewport.y = 100 - @tux.getTop()
      @viewport.y = 0 if @tux.getTop() > 100
      @updateViewport()
      
    if @tux.getBottom() + @viewport.y > @viewport.height - 100 or @viewport.y < 0
      @viewport.y = @viewport.height - 100 - @tux.getBottom()
      @viewport.y = 0 if @viewport.height - @tux.getBottom() > 100
      @updateViewport()
  
  gameEnded: ->
    if @tux.getTop() - @viewport.height > 200
      @tux.lostLive()
      
  loop: (frame) =>
    player?.loop frame       for player       in @playerObjects.getChildren()
    movingObject?.loop frame for movingObject in @movingObjects.getChildren()
    
    @sideScrolling()
    @gameEnded()

  isHit: (x, y, width, height, exclude) ->
    top = y
    left = x
    bottom = top + height
    right = left + width
    
    intersect = (go) ->
      go.getLeft() <= right &&
      go.getTop() <= bottom &&
      left <= go.getRight() &&
      top <= go.getBottom()
          
    collectionHitCheck = (collection) ->
      for shape in collection
        if shape != exclude and intersect(shape) and not shape.decoration
          return shape
      null
    
    for layer in @getAllLayers()
      if x = collectionHitCheck layer.getChildren()
        return x
        
    null

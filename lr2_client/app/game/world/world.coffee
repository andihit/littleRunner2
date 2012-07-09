StickyObject = require './base/sticky_object'
MovingObject = require './base/moving_object'
Tux = require './objects/moving/tux'
Viewport = require './viewport'

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
  
  @X_SCROLLING = 150
  @Y_SCROLLING = 80
  sideScrolling: ->
    # tux side scrolling
    if @tux.getLeft() + @viewport.x < World.X_SCROLLING
      @viewport.x = World.X_SCROLLING - @tux.getLeft()
      @updateViewport()
    
    if @tux.getRight() + @viewport.x > @viewport.width - World.X_SCROLLING
      @viewport.x = @viewport.width - World.X_SCROLLING - @tux.getRight()
      @updateViewport()
      
    if @tux.getTop() + @viewport.y < World.Y_SCROLLING or @viewport.y > 0
      @viewport.y = World.Y_SCROLLING - @tux.getTop()
      @viewport.y = 0 if @tux.getTop() > World.Y_SCROLLING
      @updateViewport()
      
    if @tux.getBottom() + @viewport.y > @viewport.height - World.Y_SCROLLING or @viewport.y < 0
      @viewport.y = @viewport.height - World.Y_SCROLLING - @tux.getBottom()
      @viewport.y = 0 if @viewport.height - @tux.getBottom() > World.Y_SCROLLING
      @updateViewport()
  
  gameEnded: ->
    if @tux.getTop() - @viewport.height > 200
      @tux.lostLive()
  
  #
  # movingObject can be deleted while traversing loop
  # same for collectionHitCheck
  #
  loop: (frame) =>
    player?.loop frame       for player       in @playerObjects.getChildren()
    movingObject?.loop frame for movingObject in @movingObjects.getChildren()
    
    @sideScrolling()
    @gameEnded()

  isHit: (x, y, width, height, checkerObject) ->
    top = y
    left = x
    bottom = top + height
    right = left + width
    
    intersect = (go) ->
      go.getLeft() <= right &&
      go.getTop() <= bottom &&
      left <= go.getRight() &&
      top <= go.getBottom()
          
    collectionHitCheck = (layer) ->
      for go in layer.getChildren()
        if go? and go != checkerObject and intersect(go)
          checkerObject.crashed go
          go.crashed checkerObject
          
          return go unless go.decoration
      null
    
    for layer in @getAllLayers()
      if x = collectionHitCheck layer
        return x
        
    null

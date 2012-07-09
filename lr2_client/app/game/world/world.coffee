StickyObject = require './base/sticky_object'
MovingObject = require './base/moving_object'
Tux = require './objects/moving/tux'
Viewport = require './viewport'
Balance = require '../balance'

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
    if @tux.getLeft() + @viewport.x < Balance.World.Scrolling.X
      @viewport.x = Balance.World.Scrolling.X - @tux.getLeft()
      @updateViewport()
    
    if @tux.getRight() + @viewport.x > @viewport.width - Balance.World.Scrolling.X
      @viewport.x = @viewport.width - Balance.World.Scrolling.X - @tux.getRight()
      @updateViewport()
      
    if @tux.getTop() + @viewport.y < Balance.World.Scrolling.Y or @viewport.y > 0
      @viewport.y = Balance.World.Scrolling.Y - @tux.getTop()
      @viewport.y = 0 if @tux.getTop() > Balance.World.Scrolling.Y
      @updateViewport()
      
    if @tux.getBottom() + @viewport.y > @viewport.height - Balance.World.Scrolling.Y or @viewport.y < 0
      @viewport.y = @viewport.height - Balance.World.Scrolling.Y - @tux.getBottom()
      @viewport.y = 0 if @viewport.height - @tux.getBottom() > Balance.World.Scrolling.Y
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

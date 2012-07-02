StickyObject = require './sticky/sticky_object'
MovingObject = require './moving/moving_object'
Viewport = require './viewport'

module.exports = class World
  
  constructor: (@game, width, height) ->
    @movingObjects = new Kinetic.Layer
    @stickyObjects = new Kinetic.Layer
    @tux = null
    
    @viewport = new Viewport width, height
    
  changeViewport: (x, y) ->
    @viewport.x = x
    @viewport.y = y
    
  applyViewport: (ctx) ->
    ctx.translate -@viewport.x, -@viewport.y
    
  applyReversedViewport: (ctx) ->
    ctx.translate @viewport.x, @viewport.y

  getCollection: (go) ->
    if go instanceof StickyObject
      @stickyObjects
    else if go instanceof MovingObject
      @movingObjects
      
  add: (go) ->
    @getCollection(go).add go
      
  remove: (go) ->
    @getCollection(go).remove go
        
  loop: (frame) ->
    go?.loop frame for go in @movingObjects.getChildren()
    
    # tux side scrolling
    right = (@tux.getRight() + 100) - (@viewport.x + @viewport.width)
    if right > 0
      @viewport.x += right
      layer.draw() for layer in [@stickyObjects, @movingObjects]
    
    left = (@tux.getLeft() - 100) - (@viewport.x)
    if left < 0
      @viewport.x += left
      layer.draw() for layer in [@stickyObjects, @movingObjects]
      
    # tux gone?
    if @tux.getTop() - @viewport.height > 100
      @game.stop()
      alert 'Tux is gone.'

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
        if shape != exclude and intersect(shape)
          return shape
      null
    
    return x if x = collectionHitCheck @stickyObjects.getChildren()
    return x if x = collectionHitCheck @movingObjects.getChildren()
    return x if x = collectionHitCheck [@tux]
    null

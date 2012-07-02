Viewport = require './viewport'

module.exports = class World
  
  constructor: (width, height) ->
    @layer = new Kinetic.Layer id: 'world'
    @viewport = new Viewport width, height
    
    @movingObjects = []
    @stickyObjects = []
    @tux = null
  
  changeViewport: (x, y) ->
    @viewport.x = x
    @viewport.y = y
    
  applyViewport: (ctx) ->
    ctx.translate -@viewport.x, -@viewport.y
    
  applyReversedViewport: (ctx) ->
    ctx.translate @viewport.x, @viewport.y

  loop: (frame, game) ->
    go.loop frame for go in @movingObjects
    
    # tux side scrolling
    right = (@tux.getRight() + 100) - (@viewport.x + @viewport.width)
    if right > 0
      @viewport.x += right
      @layer.draw()
    
    left = (@tux.getLeft() - 100) - (@viewport.x)
    if left < 0
      @viewport.x += left
      @layer.draw()
      
    # tux gone?
    if @tux.getTop() - @viewport.height > 100
      game.stop()
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
    
    return x if x = collectionHitCheck @stickyObjects
    return x if x = collectionHitCheck @movingObjects
    return x if x = collectionHitCheck [@tux]
    null

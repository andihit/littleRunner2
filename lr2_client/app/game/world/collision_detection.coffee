utils = require '../utils'

module.exports = class CollisionDetection
  
  @intersect: (go, tryObj) ->
    go.getLeft() <= tryObj.right &&
    go.getTop() <= tryObj.bottom &&
    tryObj.left <= go.getRight() &&
    tryObj.top <= go.getBottom()
  
  @intersectRect: (go, tryObj) ->
    return {
      left:   Math.max(go.getLeft(),   tryObj.left)
      right:  Math.min(go.getRight(),  tryObj.right)
      top:    Math.max(go.getTop(),    tryObj.top)
      bottom: Math.min(go.getBottom(), tryObj.bottom)
    }
  
  @crashDirection: (go, tryObj) ->
    if      tryObj.right >= go.getLeft() and tryObj.left < go.getLeft()
      'right'
    else if tryObj.left <= go.getRight() and tryObj.right > go.getRight()
      'left'
    else if tryObj.bottom >= go.getTop() and tryObj.top < go.getTop()
      'bottom'
    else if tryObj.top <= go.getBottom() and tryObj.bottom > go.getBottom()
      'top'
  
  @checkLayer: (layer, tryObj, checkerObject, sendEvents) ->
    # check every GO in this layer
    for go in layer.getChildren()
      
      # during iteration, go could be gone (eg fireball) & exclude checkerObject
      if go? and go != checkerObject and @intersect(go, tryObj)
        
        # send events?
        if sendEvents
          crashDirection = @crashDirection(go, tryObj)
          checkerObject.crashed go, crashDirection
          go.crashed checkerObject, utils.reverseDirection(crashDirection)
        
        # if it's not a decoration, there 's a hit..
        return go unless go.decoration
    null
    
  @check: (world, rect, checkerObject, sendEvents = true) ->
    [x, y, width, height] = rect
    tryObj =
      top: y
      left: x
      bottom: y + height
      right: x + width
    
    for layer in world.getAllLayers()
      if go = @checkLayer layer, tryObj, checkerObject, sendEvents
        return go
    null

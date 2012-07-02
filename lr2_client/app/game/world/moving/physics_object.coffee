MovingObject = require './moving_object'

module.exports = class PhysicsObject extends MovingObject
  
  isHit: (pointA, pointB) ->
    @shape.getStage().getIntersections(pointA).length > 0 or @shape.getStage().getIntersections(pointB).length > 0
    
  getHits: (pointA, pointB) ->
    hitsA = @shape.getStage().getIntersections(pointA)
    hitsB = @shape.getStage().getIntersections(pointB)
    hitsA.concat hitsB
    
  moveX: (diff) ->
    hitPosTop =
      x: if diff > 0 then @getRight() + diff else @getLeft() + diff
      y: @getTop()
      
    hitPosBottom =
      x: if diff > 0 then @getRight() + diff else @getLeft() + diff
      y: @getBottom()
      
    success = true
    if @isHit hitPosTop, hitPosBottom
      hitObj = @getHits(hitPosTop, hitPosBottom)[0]
      if diff < 0
        diff = -( @getLeft() - (hitObj.getX() + hitObj.getWidth()) - 1 )
      else
        diff = hitObj.getX() - @getRight() - 1
        
      success = false
      
    @shape.setX @getLeft() + diff
    @shape.getLayer().draw()
    success
    
  moveY: (diff) ->
    hitPosLeft =
      x: @getLeft()
      y: if diff > 0 then @getBottom() + diff else @getTop() + diff
      
    hitPosRight =
      x: @getRight()
      y: if diff > 0 then @getBottom() + diff else @getTop() + diff

    success = true
    if @isHit hitPosLeft, hitPosRight    
      if diff > 0 # crash bottom
        diff = @getHits(hitPosLeft, hitPosRight)[0].getY() - @getBottom() - 1
      # ignore crash on tux-top
      success = false
      
    @shape.setY @getTop() + diff
    @shape.getLayer().draw()
    success

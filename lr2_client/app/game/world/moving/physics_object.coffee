MovingObject = require './moving_object'

module.exports = class PhysicsObject extends MovingObject
    
  moveX: (diff) ->
    success = true
    
    isCrash = => @world.isHit @getLeft() + diff, @getTop(), @getWidth(), @getHeight(), @
    if isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      success = false
      
    @shape.setX @getLeft() + diff
    @shape.getLayer().draw()
    success
    
  moveY: (diff) ->
    success = true
    
    isCrash = => @world.isHit @getLeft(), @getTop() + diff, @getWidth(), @getHeight(), @
    if isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      success = false
      
    @shape.setY @getTop() + diff
    @shape.getLayer().draw()
    success

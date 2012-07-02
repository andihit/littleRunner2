MovingObject = require './moving_object'

module.exports = class PhysicsObject extends MovingObject
    
  moveX: (diff) ->
    diff = Math.round(diff)
    
    isCrash = => @world.isHit @getLeft() + diff, @getTop(), @getWidth(), @getHeight(), @
    if hitObject = isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      
    @setX @getLeft() + diff
    @getLayer().draw()
    hitObject
    
  moveY: (diff) ->
    diff = Math.round(diff)
    
    isCrash = => @world.isHit @getLeft(), @getTop() + diff, @getWidth(), @getHeight(), @
    if hitObject = isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      
    @setY @getTop() + diff
    @getLayer().draw()
    hitObject

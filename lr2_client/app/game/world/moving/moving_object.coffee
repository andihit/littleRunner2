GameObject = require '../game_object'

module.exports = class MovingObject extends GameObject
  
  moveX: (diff) ->
    diff = Math.round(diff)
    success = true
    
    isCrash = => @world.isHit @getLeft() + diff, @getTop(), @getWidth(), @getHeight(), @
    if hitObject = isCrash()
      @.crashed hitObject
      hitObject.crashed @
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      success = false
      
    @setX @getLeft() + diff
    @getLayer().draw()
    success
    
  moveY: (diff) ->
    diff = Math.round(diff)
    success = true
    
    isCrash = => @world.isHit @getLeft(), @getTop() + diff, @getWidth(), @getHeight(), @
    if hitObject = isCrash()
      @.crashed hitObject
      hitObject.crashed @
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash()
      success = false
      
    @setY @getTop() + diff
    @getLayer().draw()
    success

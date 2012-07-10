GameObject = require './game_object'

module.exports = class MovingObject extends GameObject
  
  moveX: (diff) ->
    diff = Math.round(diff)
    success = true
    
    isCrash = (sendEvents = true) =>
      @world.isHit [@getLeft() + diff, @getTop(), @getWidth(), @getHeight()], @, sendEvents
      
    if hitObject = isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash(false)
      success = false
      
    @setX @getLeft() + diff
    @getLayer().draw()
    success
    
  moveY: (diff) ->
    diff = Math.round(diff)
    success = true
    
    isCrash = (sendEvents = true) =>
      @world.isHit [@getLeft(), @getTop() + diff, @getWidth(), @getHeight()], @, sendEvents
      
    if hitObject = isCrash()
      diffTest = if diff > 0 then -1 else 1
      diff += diffTest while isCrash(false)
      success = false
      
    @setY @getTop() + diff
    @getLayer().draw()
    success

  loop: (frame) ->

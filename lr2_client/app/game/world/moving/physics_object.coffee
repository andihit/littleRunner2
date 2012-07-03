MovingObject = require './moving_object'

module.exports = class PhysicsObject extends MovingObject
    
  falling: (frame) ->
    return false if @isJumping
    
    isFalling = not @world.isHit @getLeft(), @getTop() + 1, @getWidth(), @getHeight(), @
    if isFalling
      @moveY 0.7 * frame.timeDiff
      
    isFalling

  loop: (frame) ->
    @isFalling = @falling(frame)

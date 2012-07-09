MovingObject = require './moving_object'
Balance = require 'game/balance'

module.exports = class PhysicsObject extends MovingObject
    
  falling: (frame) ->
    return false if @isJumping
    
    isFalling = not @world.isHit @getLeft(), @getTop() + 1, @getWidth(), @getHeight(), @
    if isFalling
      @moveY Balance.Player.Falling.Speed * frame.timeDiff
      
    isFalling

  loop: (frame) ->
    @isFalling = @falling(frame)

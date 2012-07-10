MovingObject = require './moving_object'
Balance = require 'game/balance'

module.exports = class PhysicsObject extends MovingObject
    
  falling: (frame) ->
    return false if @isJumping
    
    isFalling = not @world.isHit [@getLeft(), @getTop() + 1, @getWidth(), @getHeight()], @, false
    if isFalling
      @moveY Balance.Player.Falling.Speed * frame.timeDiff
      
    isFalling

  changeDirection: (newDirection) ->
    return if @direction == newDirection
    @direction = newDirection
    
    if @direction != @ImageDirection
      @setScale -1, 1
      @setOffset @getWidth(), 0
    else
      @setScale 1, 1
      @setOffset 0, 0
      
  loop: (frame) ->
    super
    @isFalling = @falling(frame)

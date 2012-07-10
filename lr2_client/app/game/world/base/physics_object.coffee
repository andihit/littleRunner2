MovingObject = require './moving_object'
Balance = require 'game/balance'

module.exports = class PhysicsObject extends MovingObject
  
  constructor: ->
    @loopStarted = false
  
  falling: (frame) ->
    return false if @isJumping
    
    # don't send events here, just checking...
    isFalling = not @world.isHit [@getLeft(), @getTop() + 1, @getWidth(), @getHeight(), 'y'], @, false
    if isFalling
      @moveY Balance.Player.Falling.Speed * frame.timeDiff
      
    isFalling

  changeDirection: (newDirection) ->
    return if @direction == newDirection
    @direction = newDirection
    
    return unless @ImageDirection
    
    if @direction != @ImageDirection
      @setScale -1, 1
      @setOffset @getWidth(), 0
    else
      @setScale 1, 1
      @setOffset 0, 0
  
  isInViewport: ->
    viewport = @world.getViewport()

    seeLeft = -viewport.x
    seeRight = seeLeft + viewport.width
    
    seeRight > @getLeft()
    
  loop: (frame) ->
    super
    
    if not @loopStarted
      if not @StartWhenVisible or (@StartWhenVisible and @isInViewport())
        @loopStarted = true
        
    if @loopStarted
      @isFalling = @falling(frame)
      true
    else
      false

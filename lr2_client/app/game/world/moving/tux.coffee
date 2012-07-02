PhysicsObject = require './physics_object'
utils = require 'game/utils'

module.exports = class Tux extends PhysicsObject
  
  constructor: (@stage, done) ->
    @load done
  
  load: (done) ->
    utils.loadImage 'images/tux.png', (img) =>
      @shape = new Kinetic.Sprite
        x: 80,
        y: 0,
        image: img,
        animation: 'standing',
        animations:
          standing: utils.getSpriteSheet 46, 66,  0, 1, 1
          walking:  utils.getSpriteSheet 46, 66,  0, 5
          small:    utils.getSpriteSheet 49, 48, 66, 7
        frameRate: 6
        fill: '#ccc'
      
      @width = 46
      @height = 66
      
      done()
  
  jumping: (frame) ->
    JUMPING_DISTANCE = 180
    moveHeight = 0.7 * frame.timeDiff
      
    if @jumpingToTop
      if @jumpingDistance + moveHeight > JUMPING_DISTANCE
        moveHeight = JUMPING_DISTANCE - @jumpingDistance
        @jumpingToTop = false
        @jumpingDistance = 0
      else
        @jumpingDistance += moveHeight
        
      unless @moveY -moveHeight
        @jumpingToTop = false
        @jumpingDistance = 0
    else
      if @jumpingDistance + moveHeight > JUMPING_DISTANCE
        moveHeight = JUMPING_DISTANCE - @jumpingDistance
        @isJumping = false
      else
        @jumpingDistance += moveHeight
        
      unless @moveY moveHeight
        @isJumping = false
      
  falling: (frame) ->
    pointLeftTux =
      x: @getLeft()
      y: @getBottom() + 1
      
    pointRightTux =
      x: @getRight()
      y: @getBottom() + 1

    isFalling = not @isHit(pointLeftTux, pointRightTux)
    if isFalling
      @moveY 0.7 * frame.timeDiff
    
    isFalling
  
  _direction: (newDirection) ->
    return if @direction == newDirection
    @direction = newDirection
    
    if @direction == 'left'
      @shape.setScale -1, 1
      @shape.setOffset @width, 0
    else
      @shape.setScale 1, 1
      @shape.setOffset 0, 0
    
  loop: (frame, keys) ->
    if keys[65] # A
      @moveX -0.25 * frame.timeDiff
      @_direction 'left'
      
    if keys[68] # D
      @moveX 0.25 * frame.timeDiff
      @_direction 'right'
    
    isFalling = if @isJumping then false else @falling(frame)
    
    if keys[87] and not @isJumping and not isFalling # W
      @isJumping = true
      @jumpingDistance = 0
      @jumpingToTop = true
    
    @jumping(frame) if @isJumping

    # change animations
    if (keys[65] or keys[68]) and @shape.getAnimation() is 'standing'
      @shape.setAnimation 'walking'
    else if not (keys[65] or keys[68]) and @shape.getAnimation() is 'walking'
      @shape.setAnimation 'standing'

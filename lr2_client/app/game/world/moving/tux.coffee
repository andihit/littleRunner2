PhysicsObject = require './physics_object'
Fireball = require './fireball'
utils = require 'game/utils'

module.exports = class Tux extends PhysicsObject
  
  constructor: (@world, x, done) ->
    @load x, done
  
  load: (x, done) ->
    utils.loadImage 'images/game/tux.png', (img) =>
      Kinetic.Sprite.call @,
        x: x,
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
      @_direction 'right'
      
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
        
      unless @moveY(-moveHeight)
        @jumpingToTop = false
        @jumpingDistance = 0
    else
      if @jumpingDistance + moveHeight > JUMPING_DISTANCE
        moveHeight = JUMPING_DISTANCE - @jumpingDistance
        @isJumping = false
      else
        @jumpingDistance += moveHeight
        
      unless @moveY(moveHeight)
        @isJumping = false
      
  falling: (frame) ->
    return false if @isJumping
    
    isFalling = not @world.isHit @getLeft(), @getTop() + 1, @getWidth(), @getHeight(), @
    if isFalling
      @moveY 0.7 * frame.timeDiff
      
    isFalling
  
  throwFireball: ->
    return if new Date().getTime() - @lastFire < 500
    
    @lastFire = new Date().getTime()
    x = if @direction == 'right' then @getRight() + 20 else @getLeft() - 20
    y = @getTop() + 20
    
    fireball = new Fireball @world, {x, y, @direction}, =>
      @world.add fireball
      fireball.drawLayer()
  
  _direction: (newDirection) ->
    return if @direction == newDirection
    @direction = newDirection
    
    if @direction == 'left'
      @setScale -1, 1
      @setOffset @width, 0
    else
      @setScale 1, 1
      @setOffset 0, 0
  
  _changeAnimations: (keys) ->
    if (keys[65] or keys[68]) and @getAnimation() is 'standing'
      @setAnimation 'walking'
    else if not (keys[65] or keys[68]) and @getAnimation() is 'walking'
      @setAnimation 'standing'
      
  loop: (frame, keys) ->
    if keys[65] # A
      @moveX -0.25 * frame.timeDiff
      @_direction 'left'
      
    if keys[68] # D
      @moveX 0.25 * frame.timeDiff
      @_direction 'right'
      
    if keys[32] # Space
      @throwFireball()
    
    isFalling = @falling(frame)
    
    if keys[87] and not @isJumping and not isFalling # W
      @isJumping = true
      @jumpingDistance = 0
      @jumpingToTop = true
    
    @jumping(frame) if @isJumping
    @_changeAnimations keys
    
  # events
  crashed: (who) ->
    if who instanceof Fireball
      @world.game.stop()
      alert 'Run into a fireball.'

Kinetic.GlobalObject.extend Tux, Kinetic.Sprite

PhysicsObject = require './physics_object'
Fireball = require './fireball'
utils = require 'game/utils'
Keys = require 'game/keys'

module.exports = class Tux extends PhysicsObject
  
  constructor: (@world, config) ->
    super
    Kinetic.Sprite.call @,
      x: config.x,
      y: config.y,
      image: @world.getGame().getResource('images/game/tux.png'),
      animation: 'standing',
      animations:
        standing: utils.getSpriteSheet 46, 66,  0, 1, 1
        walking:  utils.getSpriteSheet 46, 66,  0, 5
        small:    utils.getSpriteSheet 49, 48, 66, 7
      frameRate: 6
      fill: '#ccc'
      
    @setWidth 46
    @setHeight 66
    @_direction 'right'
    
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
  
  throwFireball: ->
    return if new Date().getTime() - @lastFire < 500
    
    @lastFire = new Date().getTime()
    x = if @direction == 'right' then @getRight() + 20 else @getLeft() - 20
    y = @getTop() + 20
    
    fireball = new Fireball @world, {x, y, @direction}
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
  
  _changeAnimations: ->
    leftOrRight = Keys.isPressed('Left') or Keys.isPressed('Right')
    
    if leftOrRight and @getAnimation() is 'standing'
      @setAnimation 'walking'
    else if not leftOrRight and @getAnimation() is 'walking'
      @setAnimation 'standing'
      
  loop: (frame) ->
    super
    
    if Keys.isPressed 'Left'
      @moveX -0.25 * frame.timeDiff
      @_direction 'left'
      
    if Keys.isPressed 'Right'
      @moveX 0.25 * frame.timeDiff
      @_direction 'right'
      
    if Keys.isPressed 'Shoot'
      @throwFireball()
    
    if Keys.isPressed('Jump') and not @isJumping and not @isFalling # W
      @isJumping = true
      @jumpingDistance = 0
      @jumpingToTop = true
    
    @jumping(frame) if @isJumping
    @_changeAnimations()
    
  # events
  crashed: (who) ->
    if who instanceof Fireball
      @world.getGame().stop()
      alert 'Run into a fireball.'

Kinetic.GlobalObject.extend Tux, Kinetic.Sprite

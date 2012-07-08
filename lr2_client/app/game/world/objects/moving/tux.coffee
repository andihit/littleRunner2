PhysicsObject = require 'game/world/base/physics_object'
Fireball = require './fireball'
utils = require 'game/utils'

module.exports = class Tux extends PhysicsObject
  
  _(@prototype).extend Kinetic.Sprite.prototype
  
  constructor: (@world, config, @keys) ->
    super
    Kinetic.Sprite.call @,
      id: config.id or 'You',
      x: config.x or 100,
      y: config.y or 100,
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
    @score = 0
    @lives = 2
  
  setScore: (score) ->
    @score = score
    @world.getGame().getHighscore().update()
    
  getScore: ->
    @score
  
  lostLive: ->
    if @lives > 0
      @lives--
      
      @setX 100
      @setY 100
      @world.getViewport().reset()
      @world.updateViewport()
    else
      @world.getGame().gameOver()
      
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
    # when firing left, X = 20px away + fireball width
    x = if @direction == 'right' then @getRight() + 20 else @getLeft() - 20 - 20
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
    leftOrRight = @keys.isPressed('Left') or @keys.isPressed('Right')
    
    if leftOrRight and @getAnimation() is 'standing'
      @setAnimation 'walking'
    else if not leftOrRight and @getAnimation() is 'walking'
      @setAnimation 'standing'
      
  loop: (frame) ->
    super
    moveDiff = => if @keys.isPressed('FastRun') then 0.5 else 0.25
      
    if @keys.isPressed 'Left'
      @moveX -moveDiff() * frame.timeDiff
      @_direction 'left'
      
    if @keys.isPressed 'Right'
      @moveX moveDiff() * frame.timeDiff
      @_direction 'right'
      
    if @keys.isPressed 'Shoot'
      @throwFireball()
    
    if @keys.isPressed('Jump') and not @isJumping and not @isFalling # W
      @isJumping = true
      @jumpingDistance = 0
      @jumpingToTop = true
    
    @jumping(frame) if @isJumping
    @_changeAnimations()
    
  # events
  crashed: (who) ->
    if who instanceof Fireball and @world.tux == @
      @lostLive()
    else
      @setScore @score + 1

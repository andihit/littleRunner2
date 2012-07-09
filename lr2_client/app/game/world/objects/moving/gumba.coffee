PhysicsObject = require 'game/world/base/physics_object'
Fireball = require './fireball'
Balance = require 'game/balance'
utils = require 'game/utils'

module.exports = class Gumba extends PhysicsObject
  
  @extend Kinetic.Sprite
  
  constructor: (@world, config) ->
    super
    
    Kinetic.Sprite.call @,
      x: config.x
      y: config.y
      image: @world.getGame().getResource('images/game/gumba.png'),
      animation: 'walking',
      animations:
        walking: utils.getSpriteSheet 57, 64,  0, 2
        down:    [{x: 46*3, y: 0, width: 57, height: 57}]
      frameRate: 3
      
    @setWidth 46
    @setHeight 66
    @_direction 'right'
    @score = config.score or 0
    @lives = config.lives or 2
  
  isMainPlayer: ->
    @ == @world.tux
  
  getScore: ->
    @score
    
  setScore: (score) ->
    @score = score
    @world.getGame().getOverlay('highscore').update()
  
  scored: (points = 1) ->
    @setScore @score + points
    
  getLives: ->
    @lives
  
  setLives: (lives) ->
    @lives = lives
    
    if @isMainPlayer()
      @world.getGame().getOverlay('lives').update()
    
  lostLive: ->
    if @lives > 0
      @setLives @lives - 1
      
      @setX Balance.World.Scrolling.X
      @setY Balance.World.Scrolling.Y
      
      if @isMainPlayer()
        @world.getViewport().reset()
        @world.updateViewport()
    else if @isMainPlayer()
      @world.getGame().gameOver()
  
  lostHalfLive: ->
    @lostLive()
    
  jumping: (frame) ->
    moveHeight = Balance.Player.Jump.Speed * frame.timeDiff
      
    if @jumpingToTop
      if @jumpingDistance + moveHeight > Balance.Player.Jump.Distance
        moveHeight = Balance.Player.Jump.Distance - @jumpingDistance
        @jumpingToTop = false
        @jumpingDistance = 0
      else
        @jumpingDistance += moveHeight
        
      unless @moveY(-moveHeight)
        @jumpingToTop = false
        @jumpingDistance = 0
    else
      if @jumpingDistance + moveHeight > Balance.Player.Jump.Distance
        moveHeight = Balance.Player.Jump.Distance - @jumpingDistance
        @isJumping = false
      else
        @jumpingDistance += moveHeight
        
      unless @moveY(moveHeight)
        @isJumping = false
  
  throwFireball: ->
    return if new Date().getTime() - @lastFire < Balance.Fireball.Throttling
    
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
    moveDiff = =>
      if @keys.isPressed('FastRun')
        Balance.Player.Move.Fast
      else
        Balance.Player.Move.Normal
    
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
    super
    # most crashed events in other GameObjects

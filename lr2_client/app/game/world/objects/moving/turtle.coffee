PhysicsObject = require 'game/world/base/physics_object'
Tux = require '../moving/tux'
Balance = require 'game/balance'
utils = require 'game/utils'

TurtleMode =
  Walking: 0
  Down: 1
  DownCrazy: 2
  
module.exports = class Turtle extends PhysicsObject
  ImageDirection: 'left'
  @extend Kinetic.Sprite
  
  constructor: (@world, config) ->
    super
    
    Kinetic.Sprite.call @,
      x: config.x
      y: config.y
      image: @world.getGame().getResource('images/game/turtle.png'),
      animation: 'walking',
      animations:
        walking: utils.getSpriteSheet 57, 64,  0, 2
        down:    [{x: 57*3, y: 0, width: 57, height: 57}]
      frameRate: 3
      
    @setWidth 57
    @setHeight 64
    @changeDirection config.direction
    @turtleMode = TurtleMode.Walking

  loop: (frame) ->
    super
    
    moveDiff = =>
      switch @turtleMode
        when TurtleMode.Walking   then Balance.Turtle.Move.Normal
        when TurtleMode.Down      then 0
        when TurtleMode.DownCrazy then Balance.Turtle.Move.Crazy
        
    if @direction == 'right'
      @moveX moveDiff() * frame.timeDiff

    else if @direction == 'left'
      @moveX -moveDiff() * frame.timeDiff

  changeAnimation: (animation) ->
    if animation == 'walking'
      @setX @getX() - (64 - 57)
      @setWidth 57
      @setHeight 64
    else
      @setWidth 57
      @setHeight 57
      @setX @getX() + (64 - 57)
      
    @setAnimation animation
    
  reverseDirection: ->
    @changeDirection utils.reverseDirection @direction
    
  crashed: (who, direction) ->
    super    
    return if who.decoration
    
    if who instanceof Tux
      if direction == 'top'
        who.triggerJumping()
        
        switch @turtleMode
          when TurtleMode.Walking
            @changeAnimation 'down'
            @turtleMode = TurtleMode.Down
            
          when TurtleMode.Down
            @turtleMode = TurtleMode.DownCrazy
            
          when TurtleMode.DownCrazy
            @turtleMode = TurtleMode.Down
        
      # if turtle is walking or crazy or direction == bottom
      else if @turtleMode != TurtleMode.Down or direction == 'bottom'
        @reverseDirection()
        who.lostHalfLive()
      else # turtle is down and left/right
        @changeDirection direction
        @turtleMode = TurtleMode.DownCrazy

    # left or right crash on wall/other elem
    else if direction == 'left' or direction == 'right'
      @reverseDirection()

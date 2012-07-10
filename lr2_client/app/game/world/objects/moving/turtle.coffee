PhysicsObject = require 'game/world/base/physics_object'
Balance = require 'game/balance'
utils = require 'game/utils'

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
        down:    [{x: 46*3, y: 0, width: 57, height: 57}]
      frameRate: 3
      
    @setWidth 57
    @setHeight 64
    @changeDirection config.direction
    @isCrazy = false

  loop: (frame) ->
    super
    moveDiff = =>
      if @isCrazy
        Balance.Turtle.Move.Crazy
      else
        Balance.Turtle.Move.Normal
    
    if @direction == 'right'
      @moveX moveDiff() * frame.timeDiff

    else if @direction == 'left'
      @moveX -moveDiff() * frame.timeDiff

  crashed: (who, direction) ->
    super    
    return if who.decoration
    
    if direction == 'left' or direction == 'right'
      @changeDirection utils.reverseDirection @direction
    else
      console.log direction

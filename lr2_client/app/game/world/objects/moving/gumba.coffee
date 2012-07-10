PhysicsObject = require 'game/world/base/physics_object'
Tux = require '../moving/tux'
Balance = require 'game/balance'
utils = require 'game/utils'

module.exports = class Gumba extends PhysicsObject
  @extend Kinetic.Sprite
  StartWhenVisible: true
  
  constructor: (@world, config) ->
    super
    
    Kinetic.Sprite.call @,
      x: config.x
      y: config.y
      image: @world.getGame().getResource('images/game/gumba.png'),
      animation: 'walking',
      animations:
        walking: utils.getSpriteSheet 32, 32,  0, 9
      frameRate: 10
      
    @setWidth 32
    @setHeight 32
    @changeDirection config.direction

  loop: (frame) ->
    return unless super
    
    if @direction == 'right'
      @moveX Balance.Gumba.Move * frame.timeDiff

    else if @direction == 'left'
      @moveX -Balance.Gumba.Move * frame.timeDiff

  reverseDirection: ->
    @changeDirection utils.reverseDirection @direction
  
  reduceHeight: =>
    curScale = @getScale().y

    if curScale - 0.1 > 0
      @setScale 1, curScale - 0.1
      
      heightDiff = @getHeight() * 0.1
      @setHeight @getHeight() - heightDiff
      @setY @getY() + heightDiff
      
      setTimeout @reduceHeight, Balance.Gumba.ReduceHeightInterval
    else
      @world.remove @
      @drawLayer()
    
  crashed: (who, direction) ->
    super    
    return if who.decoration
    
    if who instanceof Tux
      if direction == 'top'
        @changeDirection 'bottom'
        setTimeout @reduceHeight, Balance.Gumba.ReduceHeightInterval
      else
        @reverseDirection()
        who.lostHalfLive()

    # left or right crash on wall/other elem
    else if direction == 'left' or direction == 'right'
      @reverseDirection()

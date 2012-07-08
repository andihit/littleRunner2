MovingObject = require 'game/world/base/moving_object'
StickyObject = require 'game/world/base/sticky_object'

VELOCTIY = 0.4

module.exports = class Fireball extends MovingObject
  
  @extend Kinetic.Image
  
  constructor: (@world, config) ->
    super
    
    img = @world.getGame().getResource('images/game/fireball.png')
    Kinetic.Image.call @,
      x: config.x,
      y: config.y,
      image: img,
      width: img.width,
      height: img.height

    @setWidth img.width
    @setHeight img.height
    
    @distance = 0
    @stage = 0
    @flyVector = [(if config.direction == 'right' then VELOCTIY else -VELOCTIY), 0]
    
  loop: (frame) ->
    mx = @flyVector[0] * frame.timeDiff
    my = @flyVector[1] * frame.timeDiff
    @distance += Math.abs mx
    
    # stage 0 = horiz
    # stage 1 = down
    # stage 2 = up
    if (@stage == 0 and @distance >= 200) or (@stage > 0 and @stage % 2 == 0 and @distance >= 30)
      @flyVector[1] = VELOCTIY
      @stage++
      @distance = 0
      
    @moveX mx
    @moveY my
    
    @remove() if @distance >= 1000
       
  crashed: (who) ->
    if who instanceof StickyObject and @stage % 2 != 0 and @stage < 7
      @flyVector[1] = -VELOCTIY
      @stage++
      @distance = 0
    else
      @remove()
      
  remove: ->
    @world.remove @
    @drawLayer()

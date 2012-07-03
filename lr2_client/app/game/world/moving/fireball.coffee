MovingObject = require './moving_object'
StickyObject = require '../sticky/sticky_object'
utils = require 'game/utils'

VELOCTIY = 0.4

module.exports = class Fireball extends MovingObject
  
  constructor: (@world, @config, done) ->
    super
    
    @distance = 0
    @stage = 0
    @flyVector = [(if @config.direction == 'right' then VELOCTIY else -VELOCTIY), 0]
    
    @load done
    
  load: (done) ->
    utils.loadImage 'images/game/fireball.png', (img) =>
      @setWidth img.width
      @setHeight img.height
      
      Kinetic.Image.call @,
        x: @config.x,
        y: @config.y,
        image: img,
        width: @getWidth(),
        height: @getHeight()
        
      done null, @

  loop: (frame) ->
    mx = @flyVector[0] * frame.timeDiff
    my = @flyVector[1] * frame.timeDiff
    @distance += mx
    
    # stage 0 = horiz
    # stage 1 = down
    # stage 2 = up
    if (@stage == 0 and @distance >= 200) or (@stage > 0 and @stage % 2 == 0 and @distance >= 30)
      @flyVector[1] = VELOCTIY
      @stage++
      @distance = 0
      
    @moveX mx
    @moveY my
       
  crashed: (who) ->
    if who instanceof StickyObject and @stage % 2 != 0 and @stage < 7
      @flyVector[1] = -VELOCTIY
      @stage++
      @distance = 0
    else
      @world.remove @
      @drawLayer()
    
Kinetic.GlobalObject.extend Fireball, Kinetic.Image

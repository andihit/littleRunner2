PhysicsObject = require './physics_object'
utils = require 'game/utils'

module.exports = class Fireball extends PhysicsObject
  
  constructor: (@world, @config, done) ->
    super
    @load done
    
  load: (done) ->
    utils.loadImage 'images/fireball.png', (img) =>
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
    xdiff = (if @config.direction == 'right' then 0.5 else -0.5) * frame.timeDiff
    
    if (hitObj = @moveX xdiff) isnt null
      hitObj.crashed @
      @world.remove @
      @drawLayer()
    
Kinetic.GlobalObject.extend Fireball, Kinetic.Image

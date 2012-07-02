StickyObject = require './sticky_object'
utils = require 'game/utils'

module.exports = class Floor extends StickyObject
  
  constructor: (@world, @config, done) ->
    super
    Kinetic.Group.call @,
      x: @config.x
      y: @config.y
    
    @setWidth (@config.count + 2) * 62
    @setHeight 64
    @load done
  
  load: (done) ->
    utils.loadImage 'images/floor.png', (img) =>
      for i in [0 .. @config.count + 1]
        if i == 0
          spriteIndex = 0
        else if i + 1 == @config.count + 2
          spriteIndex = 2
        else
          spriteIndex = 1
          
        @add @createImage img, i * 62, 0, spriteIndex
      done null, @

  createImage: (img, x, y, spriteIndex) ->
    image = new Kinetic.Image
      x: x,
      y: y,
      image: img,
      width: 64,
      height: 64,
      crop:
        width: 64
        height: 64
        x: 64 * spriteIndex
        y: 0

Kinetic.GlobalObject.extend Floor, Kinetic.Group

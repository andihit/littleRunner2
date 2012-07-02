StickyObject = require './sticky_object'
utils = require 'game/utils'

module.exports = class Floor extends StickyObject
  
  constructor: ->
    super
    @group = new Kinetic.Group()
    
  init: (x, y, count, done) ->
    utils.loadImage 'images/floor.png', (img) =>
      for i in [0 .. count+1]
        spriteIndex = if i == 0 then 0 else (if i + 1 == count+2 then 2 else 1)
        @createImage img, x + i * 62, y, spriteIndex
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
        
    @group.add image

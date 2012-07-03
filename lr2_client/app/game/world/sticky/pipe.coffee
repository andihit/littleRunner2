StickyObject = require './sticky_object'
utils = require 'game/utils'

module.exports = class Pipe extends StickyObject
  
  constructor: (@world, @config, done) ->
    super
    Kinetic.Group.call @,
      x: @config.x
      y: @config.y
    
    @setWidth SPRITES[0].width
    @setHeight (@config.count + 1) * SPRITES[0].height
    @load done
  
  load: (done) ->
    utils.loadImage 'images/game/pipe.png', (img) =>
      for i in [0 .. @config.count]
        sprite = if i == 0 then 'top' else 'piece'
        @add @createImage img, 0, i * SPRITES[0].height, sprite
      done null, @

  createImage: (img, x, y, sprite) ->
    sprite = NAMED_SPRITES[sprite]
    
    image = new Kinetic.Image
      x: x,
      y: y,
      image: img,
      width: sprite.width,
      height: sprite.height,
      crop: sprite

Kinetic.GlobalObject.extend Pipe, Kinetic.Group


SPRITES = utils.getSpriteSheet 64, 32, 0, 1
NAMED_SPRITES =
  top: SPRITES[0]
  piece: SPRITES[1]

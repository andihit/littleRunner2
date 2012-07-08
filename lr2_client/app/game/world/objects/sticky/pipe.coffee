StickyObject = require 'game/world/base/sticky_object'
utils = require 'game/utils'

module.exports = class Pipe extends StickyObject
  
  _(@prototype).extend Kinetic.Group.prototype
  
  constructor: (@world, config) ->
    super
    Kinetic.Group.call @,
      x: config.x
      y: config.y
    
    @setWidth SPRITES[0].width
    @setHeight (config.count + 1) * SPRITES[0].height

    for i in [0 .. @config.count]
      sprite = if i == 0 then 'top' else 'piece'
      @add @createImage img, 0, i * SPRITES[0].height, sprite

  createImage: (img, x, y, sprite) ->
    sprite = NAMED_SPRITES[sprite]
    
    image = new Kinetic.Image
      x: x,
      y: y,
      image: @world.getGame().getResource('images/game/pipe.png'),
      width: sprite.width,
      height: sprite.height,
      crop: sprite


SPRITES = utils.getSpriteSheet 64, 32, 0, 1
NAMED_SPRITES =
  top: SPRITES[0]
  piece: SPRITES[1]

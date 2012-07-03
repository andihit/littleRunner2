StickyObject = require 'game/world/base/sticky_object'
utils = require 'game/utils'

module.exports = class Floor extends StickyObject
  
  constructor: (@world, config) ->
    super
    Kinetic.Group.call @,
      x: config.x
      y: config.y
    
    @setWidth (config.count + 2) * (SPRITES[0].width - 2)
    @setHeight SPRITES[0].height

    for i in [0 .. config.count + 1]
      if i == 0
        sprite = 'left'
      else if i + 1 == config.count + 2
        sprite = 'right'
      else
        sprite = 'middle'
          
      @add @createImage i * (SPRITES[0].width - 2), 0, sprite

  createImage: (x, y, sprite) ->
    sprite = NAMED_SPRITES[sprite]
    
    image = new Kinetic.Image
      x: x,
      y: y,
      image: @world.getGame().getResource('images/game/floor.png'),
      width: sprite.width,
      height: sprite.height,
      crop: sprite

Kinetic.GlobalObject.extend Floor, Kinetic.Group


SPRITES = utils.getSpriteSheet 64, 64, 0, 2
NAMED_SPRITES =
  left: SPRITES[0]
  middle: SPRITES[1]
  right: SPRITES[2]

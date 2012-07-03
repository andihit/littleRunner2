StickyImageObject = require 'game/world/base/sticky_image_object'
utils = require 'game/utils'

module.exports = class Brick extends StickyImageObject
  imageFile: 'images/game/brick.png'

  constructor: (world, config) ->
    @sprite = NAMED_SPRITES[config.color]
    super


SPRITES = utils.getSpriteSheet 42, 42, 0, 3
NAMED_SPRITES =
  blue: SPRITES[0]
  ice: SPRITES[1]
  red: SPRITES[2]
  yellow: SPRITES[3]
  brown: {x: 4*42, y: 0, width: 32, height: 32}

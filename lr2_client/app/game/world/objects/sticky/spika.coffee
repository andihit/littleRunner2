StickyImageObject = require 'game/world/base/sticky_image_object'
utils = require 'game/utils'

module.exports = class Spika extends StickyImageObject
  imageFile: 'images/game/spika.png'

  constructor: (world, config) ->
    @sprite = NAMED_SPRITES[config.color]
    super


SPRITES = utils.getSpriteSheet 32, 32, 0, 2
NAMED_SPRITES =
  green: SPRITES[0]
  grey: SPRITES[1]
  orange: SPRITES[2]

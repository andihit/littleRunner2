StickyImageObject = require 'game/world/base/sticky_image_object'

SPRITE =
  x: 0
  y: 0
  width: 42
  height: 42

module.exports = class Star extends StickyImageObject
  decoration: true
  imageFile: 'images/game/star.png'
  sprite: SPRITE

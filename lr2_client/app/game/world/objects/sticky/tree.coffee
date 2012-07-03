StickyImageObject = require 'game/world/base/sticky_image_object'

SPRITE =
  x: 0
  y: 0
  width: 200
  height: 200

module.exports = class Tree extends StickyImageObject
  decoration: true
  imageFile: 'images/game/tree.png'
  sprite: SPRITE

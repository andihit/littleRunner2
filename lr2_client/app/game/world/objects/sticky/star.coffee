StickyImageObject = require 'game/world/base/sticky_image_object'
Tux = require '../moving/tux'

SPRITE =
  x: 0
  y: 0
  width: 42
  height: 42

module.exports = class Star extends StickyImageObject
  decoration: true
  imageFile: 'images/game/star.png'
  sprite: SPRITE

  crashed: (who) ->
    if who instanceof Tux
      who.scored()
      @world.remove @
      @drawLayer()

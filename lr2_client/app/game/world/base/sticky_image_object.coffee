StickyObject = require './sticky_object'

module.exports = class StickyImageObject extends StickyObject
  
  constructor: (world, config) ->
    super

    Kinetic.Image.call @,
      x: config.x,
      y: config.y,
      image: @world.getGame().getResource(@imageFile),
      width: @sprite.width,
      height: @sprite.height,
      crop: @sprite
      
    @setWidth @sprite.width
    @setHeight @sprite.height

Kinetic.GlobalObject.extend StickyImageObject, Kinetic.Image

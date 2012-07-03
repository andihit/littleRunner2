StickyObject = require './sticky_object'
utils = require 'game/utils'

module.exports = class StickyImageObject extends StickyObject
  
  constructor: (@world, @config, done) ->
    super
    @load done
  
  load: (done) ->
    utils.loadImage @imageFile, (img) =>
      Kinetic.Image.call @,
        x: @config.x,
        y: @config.y,
        image: img,
        width: @sprite.width,
        height: @sprite.height,
        crop: @sprite
      
      @setWidth @sprite.width
      @setHeight @sprite.height
      
      done null, @

Kinetic.GlobalObject.extend StickyImageObject, Kinetic.Image

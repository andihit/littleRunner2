PhysicsObject = require './physics_object'
utils = require 'game/utils'

module.exports = class Fire extends PhysicsObject
  
  constructor: (@world) ->
    super
    
  init: (x, y, done) ->
    utils.loadImage 'images/fire.png', (img) =>
      @width = img.width
      @height = img.height
      
      @shape = new Kinetic.Image
        x: x,
        y: y,
        image: img,
        width: @width,
        height: @height
        
      done null, @

  loop: (frame) ->
    

module.exports = class GameObject
  decoration: false
  
  @extend = (KineticClass) ->
    src = KineticClass.prototype
    
    for prop of src when prop != 'constructor'
      @prototype[prop] = src[prop]
  
  constructor: (@world, config) ->
    @width = 0
    @height = 0
  
  getLeft:   -> @getX()
  getRight:  -> @getX() + @width
  getTop:    -> @getY()
  getBottom: -> @getY() + @height
  getWidth:  -> @width
  getHeight: -> @height
  
  setWidth: (width) -> @width = width
  setHeight: (height) -> @height = height
    
  getBB: ->
    {
      x: @getLeft()
      y: @getTop()
      width: @width
      height: @height
    }

  drawLayer: ->
    @getLayer().draw()
    
  crashed: (who) ->

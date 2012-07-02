
module.exports = class GameObject
  
  width: 0
  height: 0
  
  constructor: (@world) ->
    
    
  getNode: ->
    @shape or @group
  
  getLeft: ->
    @getNode().getX()
    
  getRight: ->
    @getNode().getX() + @width

  getTop: ->
    @getNode().getY()
    
  getBottom: ->
    @getNode().getY() + @height
    
  getWidth: ->
    @width
    
  getHeight: ->
    @height
    
  getBB: ->
    {
      x: @getLeft()
      y: @getTop()
      width: @width
      height: @height
    }

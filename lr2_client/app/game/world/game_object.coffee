
module.exports = class GameObject
  
  width: 0
  height: 0
  
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
    
  getBB: ->
    {
      x: @getLeft()
      y: @getTop()
      width: @width
      height: @height
    }

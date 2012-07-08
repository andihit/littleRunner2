module.exports = class Viewport

  constructor: (@width, @height) ->
    @reset()
    
  reset: ->
    @x = 0
    @y = 0

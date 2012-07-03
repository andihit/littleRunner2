
module.exports = class NetworkManager
  
  constructor: (@world) ->
    #Keys.listener = @

  # local payer
  keyDown: (keyCode) ->
    #console.log 'd',keyCode
    
  keyUp: (keyCode) ->
    #console.log 'u',keyCode
  
  
  # remove messages
  movingObjectsPositions: (positions) ->
    for position in positions
      go = @world.movingObjects.get('#' + position.id)
      go.setX position.x
      go.setY position.y
    
  dispose: ->
    Keys.listener = null

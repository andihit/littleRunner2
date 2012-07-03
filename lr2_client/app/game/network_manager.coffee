Keys = require './keys'

module.exports = class NetworkManager
  
  constructor: (@world) ->
    Keys.listener = @

  # local payer
  keyDown: (keyCode) ->
    #console.log 'd',keyCode
    
  keyUp: (keyCode) ->
    #console.log 'u',keyCode
  
  
  # remove messages
  movingObjectsPositions: (positions) ->
    for position in positions
      alert 'x'
    console.log 'for movingDingls'
    
  dispose: ->
    Keys.listener = null

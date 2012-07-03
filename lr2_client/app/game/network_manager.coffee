Tux = require './world/objects/moving/tux'
Keys = require './keys'

module.exports = class NetworkManager
  
  constructor: (@world, @localKeys) ->
    @playerKeys = {}
    @localKeys.listener = @
    # wait for movingObjectsPositions

  # local payer
  keyDown: (keyCode) ->
    
  keyUp: (keyCode) ->
  
  
  # remote messages
  movingObjectsPositions: (positions) ->
    """
    [
      {id: 'MovingObjectID', x: 0, y: 0}
    ]
    """
    for position in positions
      go = @world.movingObjects.get('#' + position.id)
      go.setX position.x
      go.setY position.y
      
  addPlayer: (player) ->
    """
    {id: 'PlayerID', x: 0, y: 0}
    """
    @playerKeys[player.id] = new Keys
    playerTux = new Tux @world, {x: player.x, y: player.y}, @playerKeys[player.id]
    @world.add playerTux
    
  keyChange: (data) ->
    """
    {id: 'PlayerID', down: true, keyCode: 65}
    """
    if data.down
      @playerKeys[data.id].keyDown data.keyCode
    else
      @playerKeys[data.id].keyUp data.keyCode
    
  dispose: ->
    @localKeys.listener = null

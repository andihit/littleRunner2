Tux = require './world/objects/moving/tux'
Keys = require './keys'

module.exports = class NetworkManager
  
  constructor: (@world, @localKeys) ->
    @playerID = null
    @playerKeys = {}
    @localKeys.listener = @
    
    @initWebsocket 'ws://localhost:4444'

  initWebsocket: (host) ->
    @ws = new WebSocket host
    @ws.onmessage = @handleMessage
    @ws.onclose = @connectionLost
    
  handleMessage: (msg) =>
    [type, data] = JSON.parse msg.data
    
    console.log type, data
    
    if type in ['id', 'newPlayer', 'requestState', 'state', 'keyChange', 'lostPlayer']
      @[type](data)
    
  connectionLost: =>
    @world.getGame().stop 'Connection lost, sorry.'


  # local payer
  keyDown: (keyCode) ->
    @ws.send JSON.stringify [
      'keyChange', {
        id: @playerID
        down: true
        keyCode: keyCode
      }
    ]
    
  keyUp: (keyCode) ->
    @ws.send JSON.stringify [
      'keyChange', {
        id: @playerID
        down: false
        keyCode: keyCode
      }
    ]
  
  
  # remote messages
  id: (id) ->
    @playerID = id
    @world.tux.setId @playerID
  
  newPlayer: (player) ->
    """
    {id: 'PlayerID', x: 0, y: 0}
    """
    @playerKeys[player.id] = new Keys
    playerTux = new Tux @world, player, @playerKeys[player.id]
    @world.add playerTux
    playerTux.drawLayer()
  
  requestState: (ref) ->
    state =
      movingObjects: []
      players: []
      
    for movingObject in @world.movingObjects.getChildren() when movingObject.getId()?
      state.movingObjects.push
        id: movingObject.getId()
        x: movingObject.getX()
        y: movingObject.getY()
    
    for player in @world.playerObjects.getChildren()
      state.players.push
        id: player.getId()
        x: player.getX()
        y: player.getY()

    @ws.send JSON.stringify ['state', [ref, state]]
    
  state: (state) ->
    """
    {
      movingObjects: [
        {id: 'MovingObjectID', x: 0, y: 0}
      ],
      players: [
        {id: 'PlayerID', x: 0, y: 0}
      ]
    }
    """
    for position in state.movingObjects
      go = @world.movingObjects.get('#' + position.id)
      go.setX position.x
      go.setY position.y
      
    @newPlayer player for player in state.players
    
  keyChange: (data) ->
    """
    {id: 'PlayerID', down: true, keyCode: 65}
    """
    if data.down
      @playerKeys[data.id].keyDown data.keyCode
    else
      @playerKeys[data.id].keyUp data.keyCode
      
  lostPlayer: (playerId) ->
    player = @world.playerObjects.get '#' + playerId
    @world.playerObjects.remove player[0]
    delete @playerKeys[playerId]
    
  stop: ->
    @ws.close()

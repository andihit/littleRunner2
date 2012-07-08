Tux = require './world/objects/moving/tux'
Keys = require './keys'

module.exports = class NetworkManager
  
  constructor: (@world, localKeys) ->
    localKeys.listener = @
    
    @isOnline = false
    @initWebsocket 'ws://localhost:4444'

  initWebsocket: (host) ->
    @ws = new WebSocket host
    @ws.onopen = => @isOnline = true
    @ws.onmessage = @handleMessage
    @ws.onerror = (error) -> console.log 'WebSocket error:',error
    @ws.onclose = @connectionLost
    
  handleMessage: (msg) =>
    [type, data] = JSON.parse msg.data
    
    if type in ['id', 'newPlayer', 'requestState', 'state', 'keyChange', 'nickChange', 'lostPlayer']
      @[type](data)
    
  connectionLost: =>
    @isOnline = false
    
    unless @world.getGame().stopped?
      @world.getGame().getHighscore().setOffline()
      

  # local payer
  keyDown: (keyCode) ->
    return unless @isOnline
    
    @ws.send JSON.stringify [
      'keyChange', {
        id: @world.tux.getId()
        down: true
        keyCode: keyCode
      }
    ]
    
  keyUp: (keyCode) ->
    return unless @isOnline
    
    @ws.send JSON.stringify [
      'keyChange', {
        id: @world.tux.getId()
        down: false
        keyCode: keyCode
      }
    ]
    
  changeNickname: (newNick) ->
    oldNick = @world.tux.getId()
    @world.tux.setId newNick
    return unless @isOnline
    
    @ws.send JSON.stringify [
      'nickChange', [oldNick, newNick]
    ]
  
  
  # remote messages
  id: (id) ->
    @world.tux.setId id
    @world.getGame().getHighscore().update()
  
  newPlayer: (player) ->
    """
    {id: 'PlayerID', x: 0, y: 0, score: 0}
    """
    playerTux = new Tux @world, player, new Keys()
    playerTux.setAlpha .6
    playerTux.setScore player.score
    @world.add playerTux
    playerTux.drawLayer()
  
  requestState: ->
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
        score: player.getScore()

    @ws.send JSON.stringify ['state', state]
    
  state: (state) ->
    """
    {
      movingObjects: [
        {id: 'MovingObjectID', x: 0, y: 0}
      ],
      players: [
        {id: 'PlayerID', x: 0, y: 0, score: 0}
      ]
    }
    """
    for position in state.movingObjects
      go = @world.movingObjects.get('#' + position.id)
      go.setX position.x
      go.setY position.y
      
    @newPlayer player for player in state.players when player.id != @world.tux.getId()
    
  keyChange: (data) ->
    """
    {id: 'PlayerID', down: true, keyCode: 65}
    """
    playerKeys = @world.playerObjects.get('#' + data.id)[0].keys
    if data.down
      playerKeys.keyDown data.keyCode
    else
      playerKeys.keyUp data.keyCode
  
  nickChange: (data) ->
    [oldNick, newNick] = data
    
    player = @world.playerObjects.get('#' + oldNick)[0]
    player.setId newNick
    
    @world.getGame().getHighscore().update()
    
  lostPlayer: (playerId) ->
    player = @world.playerObjects.get '#' + playerId
    @world.playerObjects.remove player[0]
    
  stop: ->
    @ws.close()

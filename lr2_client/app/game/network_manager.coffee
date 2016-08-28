Tux = require './world/objects/moving/tux'
Keys = require './ui/keys'

module.exports = class NetworkManager

  constructor: (@world, localKeys) ->
    localKeys.listener = @

    @isOnline = false
    @initWebsocket 'wss://localhost:4444'

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

    unless @world.getGame().isGameOver?
      @world.getGame().getOverlay('highscore').setOffline()


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
    if @world.playerObjects.get('#' + newNick).length > 0
      return false

    oldNick = @world.tux.getId()
    @world.tux.setId newNick

    if @isOnline
      @ws.send JSON.stringify [
        'nickChange', [oldNick, newNick]
      ]
    true


  # remote messages
  id: (id) ->
    @world.tux.setId id
    @world.getGame().getOverlay('highscore').update()

  newPlayer: (player) ->
    """
    # score, lives optional
    {id: 'PlayerID', x: 0, y: 0, score: 0, lives: 0}
    """
    player = new Tux @world, player, new Keys()
    player.setAlpha .6

    @world.add player
    player.drawLayer()

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
        lives: player.getLives()

    @ws.send JSON.stringify ['state', state]

  state: (state) ->
    """
    {
      movingObjects: [
        {id: 'MovingObjectID', x: 0, y: 0}
      ],
      players: [
        {id: 'PlayerID', x: 0, y: 0, score: 0, lives: 0}
      ]
    }
    """
    for position in state.movingObjects
      go = @world.movingObjects.get('#' + position.id)[0]
      go.setX position.x
      go.setY position.y

    for player in state.players when player.id != @world.tux.getId()
      existingPlayer = @world.playerObjects.get '#' + player.id
      if existingPlayer.length == 0
        @newPlayer player
      else
        existingPlayer[0].setX player.x
        existingPlayer[0].setY player.y
        existingPlayer[0].setScore player.score
        existingPlayer[0].setLives player.lives

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

    @world.getGame().getOverlay('highscore').update()

  lostPlayer: (playerId) ->
    player = @world.playerObjects.get '#' + playerId
    @world.remove player[0]

    @world.getGame().getOverlay('highscore').update()

  stop: ->
    @ws.close()

module.exports = class HighscoreOverlay
  
  constructor: (@container, @world) ->
    @isOffline = false
    @container.on 'click', @changeNickname
    
  update: ->
    text = if @isOffline then "Sorry, you 're offline.<br />" else ''
    
    players = @world.playerObjects.getChildren().slice().sort (a, b) -> b.getScore() - a.getScore()
    for player in players.slice(0, 3)
      score = player.getScore().toString()
      if score.length == 1
        score = '00' + score
      else if score.length == 2
        score = '0' + score
        
      text += "#{player.getId()}: #{score}<br />"
      
    @container.html text
      
  setOffline: ->
    @isOffline = true
    @update()
    
  changeNickname: =>
    newNick = prompt 'Your new name'
    
    until @world.getGame().changeNickname newNick
      newNick = prompt 'Nick already taken. Choose another'
      
    @update()

  dispose: ->
    @container.off 'click'

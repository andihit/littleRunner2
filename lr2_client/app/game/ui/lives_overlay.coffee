module.exports = class LivesOverlay
  
  constructor: (@container, @world) ->
    
  update: ->
    html = ''
    lives = @world.tux.getLives()
    
    while lives > 0
      html += '<img src="images/game/minitux.png" />'
      lives--
      
    @container.html html

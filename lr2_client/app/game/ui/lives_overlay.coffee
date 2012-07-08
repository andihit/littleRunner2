module.exports = class LivesOverlay
  
  constructor: (@container, @world) ->
    
  update: ->
    @world.tux.getLives()
    @container.html text

# The application bootstrapper.
Application =
  initialize: ->
    GameView = require 'views/game_view'
    Router = require 'lib/router'

    @gameView = new GameView()

    # Instantiate the router
    @router = new Router()
    # Freeze the object
    Object.freeze? this

module.exports = Application

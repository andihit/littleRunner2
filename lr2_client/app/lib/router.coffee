application = require 'application'

module.exports = class Router extends Backbone.Router
  routes:
    '': 'game'

  game: ->
    $('body').html application.gameView.el
    application.gameView.start()

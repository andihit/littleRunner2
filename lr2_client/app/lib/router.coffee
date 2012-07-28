application = require 'application'

module.exports = class Router extends Backbone.Router
  routes:
    '': 'game'
    'about': 'about'
    'imprint': 'imprint'

  game: ->
    $('#contentContainer').html application.gameView.el
    application.gameView.start()
    
  imprint: ->
    $('#contentContainer').html require 'views/templates/imprint'

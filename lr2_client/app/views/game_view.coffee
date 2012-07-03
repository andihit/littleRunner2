View = require './view'
template = require './templates/game'
Game = require 'game/game'

module.exports = class GameView extends View
  id: 'game-view'
  template: template
  
  initialize: ->
    super
    @render()
    
  start: ->
    @game = new Game
    @game.start @$el.find '#game'

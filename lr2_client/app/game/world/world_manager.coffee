class Background
  constructor: (world, config) ->
    stageContainerDOM = world.getGame().getStage().getContainer()
    $(stageContainerDOM).css 'background-image', "url(images/game/Background/#{config.name}.png)"
    
module.exports = class WorldManager

  constructor: (@world) ->
    
  @level1: ->
    Floor = require './sticky/floor'
    Brick = require './sticky/brick'
    Pipe = require './sticky/pipe'
    Tree = require './sticky/tree'
    
    [
      [Floor, {x: 0,   y: 400, count: 20}]
      [Brick, {x: 600, y: 300, color: 'brown'}]
      [Tree, {x: 400, y: 200}]
      [Background, {name: 'green_hills1'}]
      [Floor, {x: 0,   y: 300, count:  2}]
      [Floor, {x: 400, y: 300, count:  3}]
      [Floor, {x: 500, y: 200, count:  3}]
      
      [Floor, {x: -100, y: 550, count:  30}]
    ]
    
  load: (level) ->
    # load from Game.Resources
    level = WorldManager.level1()
    
    for levelGameObject in level
      [Class, config] = levelGameObject
      go = new Class @world, config
      
      @world.add(go) unless go instanceof Background

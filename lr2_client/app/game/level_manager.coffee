GameObjects = require './world/objects'

class Background
  constructor: (world, config) ->
    stageContainerDOM = world.getGame().getStage().getContainer()
    $(stageContainerDOM).css 'background-image', "url(images/game/Background/#{config.name}.png)"
    
module.exports = class LevelManager
 
  @level1: ->
    [
      ['Floor', {x: 0,   y: 400, count: 20}]
      ['Brick', {x: 600, y: 300, color: 'brown'}]
      ['Tree', {x: 400, y: 200}]
      ['Background', {name: 'green_hills1'}]
      ['Floor', {x: 0,   y: 300, count:  2}]
      ['Floor', {x: 400, y: 300, count:  3}]
      ['Floor', {x: 500, y: 200, count:  3}]
      ['Floor', {x: -100, y: 550, count:  30}]
    ]
    
  @load: (world, level) ->
    # load from Game.Resources
    level = LevelManager.level1()
    
    for gameObjectData in level
      [ClassName, config] = gameObjectData
      
      if ClassName == 'Background'
        new Background world, config
      else
        Class = GameObjects[ClassName]
        world.add new Class world, config

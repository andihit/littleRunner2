GameObjects = require './world/objects'

class Background
  constructor: (world, config) ->
    stageContainerDOM = world.getGame().getStage().getContainer()
    $(stageContainerDOM).css 'background-image', "url(images/game/Background/#{config.name}.png)"
    
module.exports = class LevelManager

  @load: (world, level) ->    
    for gameObjectData in level
      [ClassName, config] = gameObjectData
      
      if ClassName == 'Background'
        new Background world, config
      else
        Class = GameObjects[ClassName]
        world.add new Class world, config

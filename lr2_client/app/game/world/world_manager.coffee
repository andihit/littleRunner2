class Background
  constructor: (world, config, done) ->
    world.game.container.css 'background-image', "url(images/game/Background/#{config.name}.png)"
    done null, @
    
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
      #[Floor, {x: 0,   y: 300, count:  2}]
      #[Floor, {x: 400, y: 300, count:  3}]
      #[Floor, {x: 500, y: 200, count:  3}]
    ]
    
  load: (level, done) ->
    callableElements = level.map (gameObjectDef) =>
      [Class, config] = gameObjectDef
      (done) =>
        go = new Class @world, config, done
        
    async.parallel callableElements, (err, gameObjects) =>
      @world.add(go) for go in gameObjects when go not instanceof Background
      done()

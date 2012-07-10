IMAGES = [
  'images/game/tux.png'
  'images/game/floor.png'
  'images/game/brick.png'
  'images/game/pipe.png'
  'images/game/tree.png'
  'images/game/fireball.png'
  'images/game/star.png'
  'images/game/spika.png'
  'images/game/gumba.png'
  'images/game/turtle.png'
]
FILES = [
  'levels/level1.json'
]


module.exports = class Resources
  constructor: ->
    @cache = {}
  
  loadImage: (src, done) ->
    img = new Image()
    img.onload = ->
      done null, img
    img.src = src
  
  loadImages: (done) =>
    async.map IMAGES, @loadImage, (err, results) =>
      for src, i in IMAGES
        @cache[src] = results[i]
      done err
  
  loadFile: (path, done) ->
    $.getJSON path, (data) ->
      done null, data
    .error (xhr, errorName, thrownError) ->
      done thrownError
    
  loadFiles: (done) =>
    async.map FILES, @loadFile, (err, results) =>
      for path, i in FILES
        @cache[path] = results[i]
      done err
    
  load: (done) ->    
    async.parallel [
      @loadImages,
      @loadFiles
    ], (err, results) ->
      throw err if err?
      done()
    
  get: (name) ->
    unless @cache.hasOwnProperty name
      throw new Error "Cant load #{name}!"
    @cache[name]

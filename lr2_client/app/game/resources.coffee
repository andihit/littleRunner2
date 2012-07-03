IMAGES = [
  'images/game/tux.png'
  'images/game/floor.png'
  'images/game/brick.png'
  'images/game/pipe.png'
  'images/game/tree.png'
  'images/game/fireball.png'
]
FILES = [
  
]


module.exports = class Resources
  cache: {}
  
  loadImage: (src, done) ->
    img = new Image()
    img.onload = ->
      done null, img
    img.src = src
  
  load: (done) ->
    async.map IMAGES, @loadImage, (err, results) =>
      for src, i in IMAGES
        @cache[src] = results[i]
      done()
    
  get: (name) ->
    unless @cache.hasOwnProperty name
      throw new Error "Cant load #{name}!"
    @cache[name]

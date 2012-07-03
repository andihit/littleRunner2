
exports.getSpriteSheet = (width, height, startY, endFrame, startFrame=0) ->
  sprites = []
  for i in [startFrame..endFrame]
    sprites.push
      x: width * i
      y: startY
      width: width
      height: height
  sprites

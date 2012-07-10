
exports.getSpriteSheet = (width, height, startY, endFrame, startFrame=0) ->
  sprites = []
  for i in [startFrame..endFrame]
    sprites.push
      x: width * i
      y: startY
      width: width
      height: height
  sprites

exports.reverseDirection = (direction) ->
  switch direction
    when 'left' then 'right'
    when 'right' then 'left'
    when 'top' then 'bottom'
    when 'bottom' then 'top'

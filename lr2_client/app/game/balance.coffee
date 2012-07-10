# Balance File
# Speed in px/ms
# Distance in px

exports.World =
  Scrolling:
    X: 180
    Y: 80

# speed in px/ms
exports.Player =
  Move:
    Normal: 350 / 1000
    Fast: 500 / 1000
    
  Jump:
    Speed: 700 / 1000
    Distance: 180
    
  Falling:
    Speed: 700 / 1000
    
exports.Fireball =
  Throttling: 500 # throw one every .5 s
  Speed: 400 / 1000
  FlyHorizDistance: 200
  FlyTopDownDistance: 30
  MaxDistance: 1000
  
exports.Turtle =
  Move:
    Normal: 100 / 1000
    Crazy: 700 / 1000
  DownTime: 5000 # 5s
    

KEYMAP =
  Left: [65, 37]
  Right: [68, 39]
  Jump: [87, 38]
  Shoot: [32]
  FastRun: [17]

class Keys
  pressedKeys: {}
  
  keyDown: (e) =>
    return unless @isSupported e.keyCode
    
    e.preventDefault()
    @pressedKeys[e.keyCode] = true unless @pressedKeys[e.keyCode]
    
  keyUp: (e) =>
    delete @pressedKeys[e.keyCode]
    
  isPressed: (action) ->
    for key in KEYMAP[action]
      if @pressedKeys[key]
        return true
    false

  isSupported: (pressedKey) ->
    for action, keys of KEYMAP
      if pressedKey in keys
        return true
    false

module.exports = new Keys()

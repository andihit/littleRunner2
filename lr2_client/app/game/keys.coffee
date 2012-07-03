KEYMAP =
  Left: [65, 37]
  Right: [68, 39]
  Jump: [87, 38]
  Shoot: [32]
  FastRun: [17]

module.exports = class Keys
  pressedKeys: {}
  listener: null
  
  keyDown: (e) =>
    return unless @isSupported e.keyCode
    
    e.preventDefault()
    unless @pressedKeys[e.keyCode]
      @pressedKeys[e.keyCode] = true
      @listener?.keyDown e.keyCode
    
  keyUp: (e) =>
    return unless @pressedKeys[e.keyCode]
    
    delete @pressedKeys[e.keyCode]
    @listener?.keyUp e.keyCode
    
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

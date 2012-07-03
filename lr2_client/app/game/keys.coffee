KEYMAP =
  Left: [65, 37]
  Right: [68, 39]
  Jump: [87, 38]
  Shoot: [32]
  FastRun: [17]

module.exports = class Keys
  
  constructor: ->
    @pressedKeys = {}
    @listener = null
    
  keyDown: (keyCode) =>
    return if @pressedKeys[keyCode]
    
    @pressedKeys[keyCode] = true
    @listener?.keyDown keyCode
    
  keyUp: (keyCode) =>
    return unless @pressedKeys[keyCode]
    
    delete @pressedKeys[keyCode]
    @listener?.keyUp keyCode
    
  isPressed: (action) ->
    for key in KEYMAP[action]
      if @pressedKeys[key]
        return true
    false

  @isSupported: (pressedKey) ->
    for action, keys of KEYMAP
      if pressedKey in keys
        return true
    false

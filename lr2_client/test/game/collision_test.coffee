utils = require './collision_utils'

describe 'Collision', ->

  beforeEach ->
    game = utils.fakeGame()
    @world = utils.fakeWorld game
    
    @spawn = _.bind utils.spawn, null, @world, 'Brick'
    @shouldCrash = utils.shouldCrash
    @shouldNotCrash = utils.shouldNotCrash
  
  
  describe 'Right', ->
    beforeEach ->
      @world.add @brick = @spawn(42, 0)
      @shouldCrashIntoBrick = _.bind @shouldCrash, null, @brick
      
    it 'should collide right', (done) ->
      @world.isHit [5, 0, 42, 42, 'x'], @shouldCrashIntoBrick 'right', done
    
    it 'should collide right (exact)', (done) ->
      @world.isHit [0, 0, 42, 42, 'x'], @shouldCrashIntoBrick 'right', done
      
    it 'should not collide right', ->
      @world.isHit [-1, 0, 42, 42, 'x'], @shouldNotCrash
  
  
  describe 'Left', ->
    beforeEach ->
      @world.add @brick = @spawn(42, 0)
      @shouldCrashIntoBrick = _.bind @shouldCrash, null, @brick
      
    it 'should collide left (exact)', (done) ->
      @world.isHit [42+42, 0, 42, 42, 'x'], @shouldCrashIntoBrick 'left', done
      
    it 'should collide left', (done) ->
      @world.isHit [42+42 - 1, 0, 42, 42, 'x'], @shouldCrashIntoBrick 'left', done
      
    it 'should not collide left', ->
      @world.isHit [42+42 + 1, 0, 42, 42, 'x'], @shouldNotCrash


  describe 'Bottom', ->
    beforeEach ->
      @world.add @brick = @spawn(42, 42)
      @shouldCrashIntoBrick = _.bind @shouldCrash, null, @brick
      
    it 'should collide bottom (exact)', (done) ->
      @world.isHit [42, 0, 42, 42, 'y'], @shouldCrashIntoBrick 'bottom', done
      
    it 'should not collide bottom', ->
      @world.isHit [42, -1, 42, 42, 'y'], @shouldNotCrash
      
    it 'should collide bottom', (done) ->
      @world.isHit [42, 5, 42, 42, 'y'], @shouldCrashIntoBrick 'bottom', done
      
      
  describe 'Top', ->
    beforeEach ->
      @world.add @brick = @spawn(42, 42)
      @shouldCrashIntoBrick = _.bind @shouldCrash, null, @brick
      
    it 'should collide top (exact)', (done) ->
      @world.isHit [42, 42*2, 42, 42, 'y'], @shouldCrashIntoBrick 'top', done
      
    it 'should collide top', (done) ->
      @world.isHit [42, 42*2 - 5, 42, 42, 'y'], @shouldCrashIntoBrick 'top', done
      
    it 'should not collide top', ->
      @world.isHit [42, 42*2 + 1, 42, 42, 'y'], @shouldNotCrash
  
  describe 'Mixed', ->
    it 'should collide bottom', (done) ->
      @world.add @turtle = utils.spawn @world, 'Turtle', 501, 349
      @world.isHit [478, 293, 46, 66, 'y'], utils.shouldCrash @turtle, 'bottom', done

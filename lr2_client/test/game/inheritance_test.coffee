
class Base
  @extend = (KineticClass) ->
    src = KineticClass.prototype
    
    for prop of src when prop != 'constructor'
      @prototype[prop] = src[prop]
  
  constructor: ->
    @base = true
    
class Extended extends Base
  
  @extend Kinetic.Node
  
  constructor: ->
    super
    @extended = true
    
    Kinetic.Node.call @,
      id: 'KineticId'

class Extended2 extends Extended


describe 'Inheritance Chain', ->

  it 'should setup inheritance chain', ->
    e = new Extended2()
    expect(e.extended).to.be.true
    expect(e.base).to.be.true
    expect(e.getId()).to.equal 'KineticId'

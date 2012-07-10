def simple(fn):
    def wrapped(cls, go):
        config = Transformations.getXY(go)
        config.update(fn(cls, go))
        return [go.tag, config]
    return wrapped

class Transformations:
    
    @classmethod
    def getXY(cls, go):
        return {
            'x': int(go.find('Left/value').text),
            'y': int(go.find('Top/value').text) - 50
        }
        
    @classmethod
    @simple
    def Floor(cls, go):
        return {
            'blocks': int(go.find('Blocks/value').text)
        }
    
    @classmethod
    @simple
    def Pipe(cls, go):
        return {
            'blocks': int(go.find('Blocks/value').text)
        }
        
    @classmethod
    @simple
    def Brick(cls, go):
        return {
            'color': go.find('Color/value').text.lower()
        }
        
    @classmethod
    @simple
    def Star(cls, go):
        return {}
    
    @classmethod
    def DesignElements(cls, go):
        if go.find('Element/value').text == 'Tree':
            return ['Tree', Transformations.getXY(go)]
        
    @classmethod
    @simple
    def Turtle(cls, go):
        return {
            'direction': go.find('Direction/value').text.lower()
        }
        
    @classmethod
    @simple
    def Gumba(cls, go):
        return {
            'direction': go.find('Direction/value').text.lower()
        }

import xml.etree.ElementTree as ElementTree


class Converter:

    def __init__(self, src, dest):
        self.src = src
        self.dest = dest
    
    def level_settings(self, node):
        background = node.find('Background/value').text
        
        self.json.append(['Background', {'name': background.lower()}])
    
    def special_config(self, elem, go):
        config = {}
        
        if False:
            pass
        elif elem == 'Floor':
            config['blocks'] = int(go.find('Blocks/value').text)
        
        return config
    
    def game_object(self, go):
        config = {}
        
        config['x'] = int(go.find('Left/value').text)
        config['y'] = int(go.find('Top/value').text)
        config.update(self.special_config(go.tag, go))
        
        self.json.append([go.tag, config])
        
    def game_objects(self, node):
        for go in node:
            self.game_object(go)
        
    def run(self):
        tree = ElementTree.parse(self.src)
        
        root = tree.getroot()
        self.json = []
        
        self.level_settings(root.find('LevelSettings'))
        for node in root.find('Data'):
            self.game_objects(node)
            
        print self.json
    
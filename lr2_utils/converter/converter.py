import xml.etree.ElementTree as ElementTree
import json
from transformations import Transformations

class Converter:

    def __init__(self, src, dest):
        self.src = src
        self.dest = dest
    
    def level_settings(self, node):
        background = node.find('Background/value').text
        
        self.json.append(['Background', {'name': background.lower()}])
    
    def game_object(self, go):
        name = go.tag
        
        if hasattr(Transformations, name):
            json_element = getattr(Transformations, name)(go)
            
            if json_element:
                self.json.append(json_element)
        
    def game_objects(self, node):
        for go in node:
            self.game_object(go)
    
    def write_file(self):
        with open(self.dest, 'w') as f:
            json.dump(self.json, f, indent=4)
    
    def run(self):
        tree = ElementTree.parse(self.src)
        
        root = tree.getroot()
        self.json = []
        
        self.level_settings(root.find('LevelSettings'))
        for node in root.find('Data'):
            self.game_objects(node)
        
        self.write_file()
        for x in self.json:
            print x
    
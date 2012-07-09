import sys
from converter import Converter

def usage():
    print 'convert.py source destination'
    
if __name__ == '__main__':
    if len(sys.argv) != 3:
        usage()
        sys.exit(1)
        
    c = Converter(sys.argv[1], sys.argv[2])
    c.run()

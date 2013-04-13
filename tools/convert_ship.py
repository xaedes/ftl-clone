#!/usr/bin/env python2

import sys
import array
from struct import unpack
from os.path import dirname, basename, exists
from os import makedirs
import json

assert len(sys.argv) >= 2

filename = sys.argv[1]

keys = {"ROOM":["id", "x", "y", "w", "h"],"DOOR":["x", "y", "id1", "id2","direction"]}

with open(filename, "r") as f:
    lines = [line.strip() for line in f]
    
    i = 0
    objs = {"ROOM":[],"DOOR":[]}
    while i < len(lines):
        if lines[i] in keys.keys():
            obj = dict( zip( keys[lines[i]], map( int, lines[i+1:i+1+len(keys[lines[i]])] ) ) )
            objs[lines[i]].append(obj)
            i += len(keys[lines[i]])
        i += 1
        
    print json.dumps({"rooms":objs["ROOM"],"doors":objs["DOOR"]}, indent=4, separators=(',', ': ')) #.replace('"','')
    exit(0)
    

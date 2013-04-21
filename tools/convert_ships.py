#!/usr/bin/env python2

import sys
import array
import os
import glob
from struct import unpack
from os.path import dirname, basename, exists, splitext, normpath, join
from os import makedirs
import json

from bs4 import BeautifulSoup # http://www.crummy.com/software/BeautifulSoup, lenient xml parser

assert len(sys.argv) >= 2

# Reads all ships (as txt and xml) in current directory and stores them as json in specified output directory
# Usage:
# tools> cd data
# data> python2 ../convert_ships.py ../../src/data/ships



output_dir = normpath(sys.argv[1])

def readTXT(filename,data):

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
            
        data["rooms"] = objs["ROOM"]
        data["doors"] = objs["DOOR"]

    return data

def readXML(filename,data):
    with open(filename, "r") as f:
        file = f.read()
        soup  = BeautifulSoup(file)
        
        data["tile_offset"] = {}
        data["tile_offset"]["x"] = int(soup.img.attrs["x"])
        data["tile_offset"]["y"] = int(soup.img.attrs["y"])

    return data

# Look for all *.txt files
# If there exists a corresponding xml file, it is a ship
# Read data of all ship and save it in file
for infile in glob.glob( os.path.join('', '*.txt') ):
    shipname = splitext(infile)[0]
    if( exists("%s.xml" % shipname) ):
        data = {}
        data["tile_size"] = 35
        readTXT("%s.txt" % shipname, data)
        readXML("%s.xml" % shipname, data)
        with open(join(output_dir,"%s.json" % shipname),"w") as f:
            f.write(json.dumps(data, indent=4, separators=(',', ': ')))
        # print splitext(infile)[0]
exit(0)

print json.dumps(data, indent=4, separators=(',', ': ')) #.replace('"','')
# exit(0)
    

#!/usr/bin/env python2

import sys
import array
import os
import glob
from struct import unpack
from os.path import dirname, basename, exists, splitext, normpath, join
from os import makedirs
import json

from parse import parse

from bs4 import BeautifulSoup # http://www.crummy.com/software/BeautifulSoup, lenient xml parser


# Reads all ships (as txt and xml) in current directory and stores them as json in specified output directory
# Usage:
# tools> cd data
# data> python2 ../convert_ships.py ../../src/data/ships

assert len(sys.argv) >= 2
output_dir = normpath(sys.argv[1])

def read_txt(filename,data):

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

def read_xml(filename,data):
    with open(filename, "r") as f:
        file = f.read()
        soup  = BeautifulSoup(file)
        
        data["tile_offset"] = {}
        data["tile_offset"]["x"] = int(soup.img.attrs["x"])
        data["tile_offset"]["y"] = int(soup.img.attrs["y"])

    return data

def read_blueprints(filename):
    blueprints = dict()
    def read_ship_blueprint(tag):
        name,attrs,childs = tag

        blueprint = dict()

        def read_leaf(tag):
            name,attrs,childs = tag
            return (name,childs[0])
        
        def is_leaf(tag):
            name,attrs,childs = tag
            return (len(childs)==1) and (type(childs[0])==str)

        def read_system_list(tag):
            name,attrs,childs = tag

            def read_system(tag):
                name,attrs,childs = tag
                system = dict()
                system["name"] = name

                system.update(attrs)

                def read_slot(tag):
                    name,attrs,childs = tag

                    slot = dict()
                    for child in childs:
                        if type(child) == str:
                            pass
                        elif is_leaf(child):
                            key, val = read_leaf(child)
                            slot[key] = val

                    return slot

                for child in childs:
                    if (type(child) == tuple) and (child[0] == "slot"):
                        system["slot"] = read_slot(child)

                return system

            system_list = list()
            for child in childs:
                if type(child) == tuple:
                    system_list.append(read_system(child))

            return system_list

        for child in childs:
            if type(child) == str:
                pass
            elif is_leaf(child):
                key, val = read_leaf(child)
                blueprint[key]=val
            elif child[0] == "systemList":
                blueprint[child[0]] = read_system_list(child)

        return blueprint

    with open(filename, "r") as f:
        file = f.read()
        xml = parse(file)

        for tag in xml:
            if type(tag) == tuple:
                name,attrs,childs = tag
                if name == "shipBlueprint":
                    if not blueprints.has_key(name):
                        blueprints[name] = dict()

                    blueprints[name][attrs["layout"]] = read_ship_blueprint(tag)

    return blueprints   

blueprints = read_blueprints('blueprints.xml')


# Look for all *.txt files
# If there exists a corresponding xml file, it is a ship
# Read data of all ship and save it in file
for infile in glob.glob( os.path.join('', '*.txt') ):
    shipname = splitext(infile)[0]
    if( exists("%s.xml" % shipname) ):
        data = {}
        data["tile_size"] = 35
        read_txt("%s.txt" % shipname, data)
        read_xml("%s.xml" % shipname, data)

        if blueprints["shipBlueprint"].has_key(shipname):
            data.update(blueprints["shipBlueprint"][shipname])

        # Create ouput directory when necessary
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        with open(join(output_dir,"%s.json" % shipname),"w") as f:
            f.write(json.dumps(data, indent=4, separators=(',', ': ')))


sys.exit(0)

print json.dumps(data, indent=4, separators=(',', ': ')) #.replace('"','')
# exit(0)
    

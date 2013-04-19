#!/usr/bin/env python2

from struct import unpack
from os.path import dirname, basename, exists, normpath, join
from os import makedirs

# Extracts all ftl resources in current directory into current directory


def extract(filename):
	with open(filename, "rb") as f: 
		f.seek(4) # Seek to begin

		begin = unpack('<I', f.read(4))[0]
		print begin
		f.seek(begin)
		
		while(True):
			filesize = f.read(4)
			if(filesize == ""):
				break
			filesize = unpack('<I', filesize)[0]
			filename_length = unpack('<I', f.read(4))[0]

			filename = f.read(filename_length)
			data = f.read(filesize)

			if not exists( dirname(filename) ):
				makedirs( dirname(filename) )

			with open(filename, "wb") as output: 
				output.write(data)

			print filesize, filename_length, filename


extract("resource.dat")
extract("data.dat")
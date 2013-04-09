coffee:
	coffee -m -o src/js -j all -c `find src/coffee/ -iname *.coffee`

watch:
	coffee -m -w -o src/js -j all -c `find src/coffee/ -iname *.coffee`

server: coffee
	cd src && python2 -m SimpleHTTPServer

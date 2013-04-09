coffee:
	coffee -m -o public/js -j all -c `find src/ -iname *.coffee`

watch:
	coffee -m -w -o public/js -j all -c `find src/ -iname *.coffee`

server: coffee
	cd public && python -m SimpleHTTPServer

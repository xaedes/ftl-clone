tab2space:
	find src/coffee/ -iname *.coffee -exec sed -i s/'\t'/'    '/g '{}' \;

coffee:
	coffee -m -o src/js -c src/coffee/
#	coffee -m -o src/js -c `find src/coffee/ -iname *.coffee`

watch:
	coffee -m -w -o src/js/ -c src/coffee/
#	coffee -m -w -o src/js -c `find src/coffee/ -iname *.coffee`

server: coffee
	python2 -m SimpleHTTPServer

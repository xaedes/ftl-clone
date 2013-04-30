
coffee:
	coffee -m -o src/js/ -c src/coffee/
#	coffee -m -o src/js -c `find src/coffee/ -iname *.coffee`

watch:
	coffee -m -w -o src/js/ -c src/coffee/
#	coffee -m -w -o src/js -c `find src/coffee/ -iname *.coffee`

server: coffee
	http-server . -p 8000

tab2space:
	find src/coffee/ -iname *.coffee -exec sed -i s/'\t'/'    '/g '{}' \;

extract_resources:
	cd ftl-resources; \
	python2 ../tools/extract.py

extract_ships:
	cd ftl-resources/data/; \
	python2 ../../tools/convert_ships.py ../../src/data/ships
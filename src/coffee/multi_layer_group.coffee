define([],()->
	class MultiLayerGroup extends Kinetic.Group
		# Implements a multi layer object with a Group for every layer
		# Itself as a Group can be contained in some specific layer, but it has now real meaning.

        constructor: (config) ->
            Kinetic.Group.call(@, config) #Call super constructor

            @layers = {}
            for layername, layer of @attrs["layers"]
            	@layers[layername] = new Kinetic.Group(config)
            	layer.add(@layers[layername])

            @setAttr = (key, val) ->
            	for layername, layer of @layers
            		layer.setAttr(key, val)

    return MultiLayerGroup
)
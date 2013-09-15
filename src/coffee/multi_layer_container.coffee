define(["init"],(init)->
	class MultiLayerContainer extends Kinetic.Container
		# Implements a multi layer object with a Group for every layer
        # Itself can be contained in a Stage or other MultiLayerContainer objects

        constructor: (config) ->
            @createAttrs()
            @attrs.stage = init.stage
            @attrs.layers = @attrs.stage.getChildren()

            #Call super constructor
            Kinetic.Container.call(@, config)

            # Add Group objects to every layer in @attrs.stage
            this.parent = @attrs.stage
            @groups = {}
            for layer in @attrs.layers
                @groups[layer.name] = new Kinetic.Group(config)
                layer.add(@groups[layer.name])


            @oldAdd = @add
            @add = (child) =>
                if child instanceof MultiLayerContainer
                    @oldAdd(child)

                    # set parent of child's Groups to corresponding Groups of @
                    for layername, group of child.groups
                        group.remove()
                        @groups[layername].add(group)

                else
                    # add child to correct Group
                    if @groups[child.attrs.layer]?
                        @groups[child.attrs.layer].add(child)
                    else
                        console.log("layer " + child.attrs.layer + " not found in MultiLayerContainer")

            @oldSetAttr = @setAttr
            @setAttr = (key, val) =>

                @oldSetAttr(key, val)
                # pass attr changes to groups
                for layername, group of @groups
                    group.setAttr(key, val)

            @oldDraw = @draw
            @draw = () =>
                for layername, group of @groups
                    group.draw()   

    return MultiLayerContainer
)
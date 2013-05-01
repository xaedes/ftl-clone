define(["init","animations/doors","multi_layer_container"],(init,animations,MultiLayerContainer)->

    class Door extends MultiLayerContainer
        constructor: (config) ->
            # Default attrs
            @attrs = 
                selectable: true
            
            # Call super constructor
            super(config) 
            # Kinetic.Group.call(@, config) 
            
            @data = @attrs.data
            @ship = @attrs.ship

            # Set position
            @setX( @data.x * @ship.data.tile_size - @ship.data.tile_offset.x ) 
            @setY( @data.y * @ship.data.tile_size - @ship.data.tile_offset.y ) 

            # Create child objects
            @sprite = new Kinetic.Sprite(
                image: animations.doors.image
                animation: "level1"
                animations: animations.doors.animations
                frameRate: 4
                index: 0
                layer: "doors"
            )
            @highlight = new Kinetic.Image(
                image: animations.highlight.image
                opacity: 0.5
                layer: "doors"
            )
            @highlight.hide()
            
            @selectionArea = new Kinetic.Rect(
                width: 13
                height: 18
                x: 10
                y: 8
                layer: "selection_areas"
            )
            @add(@highlight)
            @add(@sprite)
            @add(@selectionArea)

            # Set offset and rotation based on direction of door
            halfTile = Math.round(35/2)

            @setOffset(halfTile,halfTile)

            if @data.direction == 0 # up
                @setRotationDeg(90)
                @move(+halfTile-2,0)
            else # left
                @move(0,+halfTile)





            if @attrs.selectable
                # Set event listeners for highlighting

                @selectionArea.on("mouseenter",()=>
                    document.body.style.cursor = 'pointer'
                    @highlight.show()
                    @draw()
                )
                @selectionArea.on("mouseleave",()=>
                    document.body.style.cursor = 'default'
                    @highlight.hide()

                    # redraw the whole layer for clearing
                    @highlight.getLayer().draw() 
                )            
                @selectionArea.on("click",()=>
                    @toggleState()
                )

        toggleState: () ->
            switch @state
                when "open"
                    @setState("closing")
                
            
        setState: (newState) ->
            if @state == newState
                return

            @state = newState
            # switch @state
            #     when "closing"
                    
                
            

        update: (elapsedTime) ->
            # @sprite.start()


            

    return Door

)
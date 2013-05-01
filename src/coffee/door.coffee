define(["animations/doors"],(animations)->

    class Door extends Kinetic.Group
        constructor: (config) ->
            @attrs = 
                selectable: true
            
            Kinetic.Group.call(@, config) #Call super constructor
            
            @data = @attrs.data
            @ship = @attrs.ship

            @setX( @data.x * @ship.data.tile_size - @ship.data.tile_offset.x ) 
            @setY( @data.y * @ship.data.tile_size - @ship.data.tile_offset.y ) 

            @sprite = new Kinetic.Sprite(
                image: animations.doors.image
                animation: "level1"
                animations: animations.doors.animations
                frameRate: 4
                index: 0
            )
            @highlight = new Kinetic.Image(
                image: animations.highlight.image
            )
    

            halfTile = Math.round(35/2)

            @setOffset(halfTile,halfTile)

            if @data.direction == 0 # up
                @setRotationDeg(90)
                @move(+halfTile-2,0)
            else # left
                @move(0,+halfTile)

            @add(@sprite)

            @highlight_group = new Kinetic.Group()
            @add(@highlight_group)
            
            @selectionArea = new Kinetic.Rect(
                # stroke: "black"
                width: 13
                height: 18
                x: 10
                y: 8
            )
            @add(@selectionArea)

            if @attrs.selectable

                @selectionArea.on("mouseenter",()=>
                    @highlight_group.add(@highlight)

                    document.body.style.cursor = 'pointer'
                    @getLayer().draw()
                    # @draw()
                )
                @selectionArea.on("mouseleave",()=>
                    @highlight.remove()
                    document.body.style.cursor = 'default'
                    @getLayer().draw()
                    # @draw()
                )            


        update: (elapsedTime) ->
            # @sprite.start()


            

    return Door

)
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
                opacity: 0.5
            )
    

            halfTile = Math.round(35/2)

            @setOffset(halfTile,halfTile)

            if @data.direction == 0 # up
                @setRotationDeg(90)
                @move(+halfTile-2,0)
            else # left
                @move(0,+halfTile)


            @highlight_group = new Kinetic.Group()
            
            @selectionArea = new Kinetic.Rect(
                width: 13
                height: 18
                x: 10
                y: 8
            )

            @add(@highlight_group)
            @add(@sprite)
            @add(@selectionArea)

            if @attrs.selectable

                @selectionArea.on("mouseenter",()=>
                    document.body.style.cursor = 'pointer'
                    @highlight_group.add(@highlight)
                    @draw()
                )
                @selectionArea.on("mouseleave",()=>
                    document.body.style.cursor = 'default'
                    @highlight.remove()

                    # redraw the whole layer for clearing
                    @getLayer().draw() 
                )            


        update: (elapsedTime) ->
            # @sprite.start()


            

    return Door

)
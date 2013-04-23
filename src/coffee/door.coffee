define(["animations/doors"],(animations)->

    class Door extends Kinetic.Group
        constructor: (config) ->
            @attrs = {}
            Kinetic.Group.call(@, config) #Call super constructor
            
            @data = @attrs.data
            @ship = @attrs.ship

            @setX( @data.x * @ship.data.tile_size - @ship.data.tile_offset.x ) 
            @setY( @data.y * @ship.data.tile_size - @ship.data.tile_offset.y ) 

            sprite = new Kinetic.Sprite(
                image: animations.image
                animation: "level1"
                animations: animations.animations
                frameRate: 4
                index: 4
            )
            # sprite.start()

            halfTile = Math.round(35/2)

            @setOffset(halfTile,halfTile)

            if @data.direction == 0 # up
                @setRotationDeg(90)
                @move(+halfTile-2,0)
            else # left
                @move(0,+halfTile)

            @add(sprite)

        update: (elapsedTime) ->
            # @sprite.start()


            

    return Door

)
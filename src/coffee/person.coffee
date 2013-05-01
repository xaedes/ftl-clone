define(["init","assets","animations","multi_layer_container"], \
        (init, Assets, animations,MultiLayerContainer) ->
            
    class Person extends MultiLayerContainer
        constructor: (config) ->
            #http://stackoverflow.com/questions/14530450/coffeescript-class/14536430#14536430

            # Default attrs
            @attrs = 
                selectable: true
                selected: false
                tile_x: 0
                tile_y: 0
                tile_speed: 2/1000


            #Call super constructor
            super(config)
            # Kinetic.Group.call(@, config) 

            if @attrs.race not in animations.persons.races
                console.log "Error. Unknown person type!"
                return

            @sprites = {}
            for color in animations.persons[@attrs.race].colors
                @sprites[color] =  new Kinetic.Sprite(
                    x: 0
                    y: 0
                    image: animations.persons[@attrs.race][color].image
                    animation: 'right'
                    animations: animations.persons[@attrs.race].yellow.walking
                    frameRate: 16
                    index: 0
                    layer: "persons"
                )

            # @spriteContainer = new Kinetic.Group(
            #     layer: "persons"
            # )
            # @add(@spriteContainer)

            @sprite = 
                color: "yellow"
                action: "standing"
                direction: "down"
                update: () =>
                    @sprites[@sprite.color].attrs.animations = animations.persons[@attrs.race][@sprite.color][@sprite.action]
                    @sprites[@sprite.color].attrs.animation = @sprite.direction
                    if(@sprites[@sprite.color].attrs.index >= @sprites[@sprite.color].attrs.animations[@sprite.direction].length)
                        @sprites[@sprite.color].attrs.index = 0

                    if(@active_sprite == @sprites[@sprite.color])
                        return

                    @active_sprite.remove() if @active_sprite?
                    @active_sprite.stop() if @active_sprite?

                    @active_sprite = @sprites[@sprite.color]
                    @add(@active_sprite)
                    @active_sprite.start()


            @selectionArea = new Kinetic.Circle(
                radius: 16/2
                x: 35/2-1
                y: 35/2-1
                # stroke: "red"
                layer: "selection_areas"
            )
            @add(@selectionArea)
            @draw()

            if @attrs.selectable
                @selectionArea.on("mouseenter",()=>
                    @sprite.color = "highlight" if not @attrs.selected
                    document.body.style.cursor = 'pointer'
                    @sprite.update()
                )
                @selectionArea.on("mouseleave",()=>
                    @sprite.color = "yellow" if not @attrs.selected
                    document.body.style.cursor = 'default'
                    @sprite.update()
                )



        setTileXY: (tx,ty) ->
            @x = tx * @ship.data.tile_size - @ship.data.tile_offset.x
            @y = ty * @ship.data.tile_size - @ship.data.tile_offset.y



        update: (elapsedTime) ->
            @mission.update(elapsedTime) if @mission?
            @setX( @attrs.tile_x * @ship.data.tile_size - @ship.data.tile_offset.x ) 
            @setY( @attrs.tile_y * @ship.data.tile_size - @ship.data.tile_offset.y )
            @selectionArea.getLayer().draw()            

        
    return Person
)
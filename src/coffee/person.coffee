define(["init","assets","animations"], \
        (init, Assets, animations) ->
            
    class Person extends Kinetic.Container
        constructor: (config) ->
            #http://stackoverflow.com/questions/14530450/coffeescript-class/14536430#14536430
            @attrs = 
                selectable: true
                tile_x: 0
                tile_y: 0
                tile_speed: 1/1000
            Kinetic.Container.call(@, config) #Call super constructor

            if @attrs.race not in animations.persons.races
                console.log "Error. Unknown person type!"
                return

            @attrs.layer.add(@)


            @sprites = {}
            for color in animations.persons[@attrs.race].colors
                @sprites[color] =  new Kinetic.Sprite(
                    x: 0
                    y: 0
                    image: animations.persons[@attrs.race][color].image
                    animation: 'right'
                    animations: animations.persons[@attrs.race].yellow.walking
                    frameRate: 4
                    index: 0
                )

            @spriteContainer = @
            @sprite = 
                color: "green"
                action: "walking"
                direction: "right"
                update: () =>
                    @sprites[@sprite.color].attrs.animations = animations.persons[@attrs.race][@sprite.color][@sprite.action]
                    @sprites[@sprite.color].attrs.animation = @sprite.direction

                    if(@active_sprite == @sprites[@sprite.color])
                        return

                    @active_sprite.remove() if @active_sprite?
                    @active_sprite.stop() if @active_sprite?

                    @active_sprite = @sprites[@sprite.color]
                    @spriteContainer.add(@active_sprite)
                    @active_sprite.start()

            @sprite.update()

            # @updater = new Kinetic.Animation(()=>
            #     @update.call(@)
            # ,@)
            # @updater.start()
            

            init.stage.draw()

        setTileXY: (tx,ty) ->
            @x = tx * @ship.tile_size + @ship.tile_offset.x
            @y = ty * @ship.tile_size + @ship.tile_offset.y



        update: (elapsedTime) ->
            @mission.update(elapsedTime) if @mission?
            @setX( @attrs.tile_x * 35 )
            @setY( @attrs.tile_y * 35 )
           
            

        
    return Person
)
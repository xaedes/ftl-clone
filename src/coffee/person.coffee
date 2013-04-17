define(["init","assets","animations"], \
        (init, Assets, animations) ->
            
    class Person extends Kinetic.Container
        selectable: true
        constructor: (config) ->
            #http://stackoverflow.com/questions/14530450/coffeescript-class/14536430#14536430
            @attrs = {}
            Kinetic.Container.call(@, config) #Call super constructor

            if @attrs.race not in animations.persons.races
                console.log "Error. Unknown person type!"
                return

            @attrs.layer.add(@)


            @sprites = {}
            for color in animations.persons[@attrs.race].colors
                @sprites[color] =  new Kinetic.Sprite(
                    x: 100
                    y: 100
                    image: animations.persons[@attrs.race][color].image
                    animation: 'right'
                    animations: animations.persons[@attrs.race].yellow.walking
                    frameRate: 4
                    index: 0
                )

            @spriteContainer = @
            @sprite = 
                color: "green"
                action: "standing"
                direction: "right"
                update: () =>
                    @sprites[@sprite.color].attrs.animations = animations.persons[@attrs.race][@sprite.color][@sprite.action]
                    @sprites[@sprite.color].attrs.animation = @sprite.direction

                    @active_sprite.remove() if @active_sprite?
                    @active_sprite.stop() if @active_sprite?

                    @active_sprite = @sprites[@sprite.color]
                    @spriteContainer.add(@active_sprite)
                    @active_sprite.start()

            @sprite.update()

            # @add(@sprite)
            

            init.stage.draw()


        
    return Person
)
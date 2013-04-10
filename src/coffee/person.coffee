define(["sprite_settings"], (sprites) ->


    Person = {
        init: () ->
            switch @race
                when "human" then @sprite_settings = sprites.human.normal_right
                else 
                    console.log "Error. Unknown person type!"
            @updatePosition()

            sprite = @core.display.sprite( @sprite_settings )
            @core.addChild(sprite);
        
        draw: () ->
            # update

        updatePosition: () ->
            @sprite_settings.x = @x
            @sprite_settings.y = @y

    }
    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init");

    
)
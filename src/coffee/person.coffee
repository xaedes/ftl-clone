define(["sprite_settings"], (sprites) ->


    Person = {
        init: () ->
            @sprite_settings = sprites.human.normal_right
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
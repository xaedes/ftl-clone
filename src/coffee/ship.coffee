define(["init","sprite_settings"], (init,sprites) ->


    Ship = {
        init: () ->
            switch @model
                when "kestral" then @sprite_settings = sprites.ship.kestral
                else 
                    console.log "Error. Unknown ship model!"
            @updatePosition()

            background = @core.display.image( @sprite_settings )
            @core.addChild(background);
        
        draw: () ->
            # update

        updatePosition: () ->
            @sprite_settings.x = @x
            @sprite_settings.y = @y

    }
    
    shipObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Ship, settings)

    oCanvas.registerDisplayObject("ship", shipObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.ship = oCanvas.modules.display.ship.setCore(init.canvas)
    
)
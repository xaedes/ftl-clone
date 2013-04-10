define(["init","sprite_settings"], (init,sprites) ->


    Ship = {
        init: () ->
            switch @model
                when "kestral" then @sprite_settings = sprites.ships.kestral
                else 
                    console.log "Error. Unknown ship model!"
            @updatePosition()

            floor = @core.display.image( @sprite_settings.floor )
            base = @core.display.image( @sprite_settings.base )
            @addChild(base)
            @addChild(floor)
        
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
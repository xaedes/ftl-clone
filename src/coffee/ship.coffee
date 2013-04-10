define(["init","sprite_settings","container"], (init,sprites,Container) ->
    Ship = {
        init: () ->
            switch @model
                when "kestral" then @sprite_settings = sprites.ships.kestral
                else 
                    console.log "Error. Unknown ship model!"
            @updatePosition()
            
            floor = @core.display.image( @sprite_settings.floor )
            base = @core.display.image( @sprite_settings.base )

            @background = init.canvas.display.container({})
            @background.addChild(base)
            @background.addChild(floor)

            @addChild(@background)
        
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
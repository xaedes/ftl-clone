define(["init","sprite_settings"], (init,sprites) ->


    Person = 
        init: () ->
            if @race not in ["human"] 
                console.log "Error. Unknown person type!"
                return
            @sprite_settings = sprites.persons[@race].yellow.walking.right

            sprite = @core.display.sprite( @sprite_settings )
            @addChild(sprite);
        
        draw: () ->
            # update
        
        update: () ->
            @x++
            @x = Math.min(500,@x)
            
    
    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.person = oCanvas.modules.display.person.setCore(init.canvas)
    
)
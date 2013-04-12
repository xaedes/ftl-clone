define(["init","sprite_settings","container"], (init,sprites,Container) ->
    Ship = 
        init: () ->
            switch @model
                when "kestral" 
                    @sprite_settings = sprites.ships.kestral
                    @tile_offset = 
                        x: 71
                        y: 116
                    @tile_size = 35 
                else 
                    console.log "Error. Unknown ship model!"
            
            floor = @core.display.image( @sprite_settings.floor )
            base = @core.display.image( @sprite_settings.base )
            
            @background = init.canvas.display.container({})
            @background.addChild(base)
            @background.addChild(floor)
            
            @addChild(@background)
            
            @bind("click tap",(event) => 
                event.stopPropagation()
                if @selected_person?
                    switch event.which
                        when 1 # left click
                            @selected_person.sprite.color = "yellow"
                            @selected_person.sprite.update()
                            @selected_person = null
                        when 2 # right click
                            tile_pos = @calculateTileXY(event.x, event.y)
                            @selected_person.moveToTileXY(tile_pos.x,tile_pos.y)
            )
        
        calculateTileXY: (x,y,precision=false) ->
            tile_pos = 
                x: (x - @tile_offset.x) / @tile_size
                y: (y - @tile_offset.y) / @tile_size
            if not precision
                tile_pos.x = Math.floor(tile_pos.x)
                tile_pos.y = Math.floor(tile_pos.y)
            return tile_pos

        
        draw: () ->
            # update
        
        addPerson: (person) ->
            person.ship = this
            @addChild(person)
            person.bind("click tap",(event) =>
                # Select
                @selected_person = person
                @selected_person.sprite.color = "green"
                @selected_person.sprite.update()
                event.stopPropagation()
            )
        
    
    shipObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend({}, Ship, settings)

    oCanvas.registerDisplayObject("ship", shipObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.ship = oCanvas.modules.display.ship.setCore(init.canvas)
    
)
define(["init","sprite_settings"], (init,sprites) ->
    
    SimpleMovement =
        create: (person, x, y) ->
            return oCanvas.extend({person:person,x:x,y:y},SimpleMovement)
            
        update: () ->
            dx = @x - @person.x
            dy = @y - @person.y 
            dx = if dx == 0 then dx else dx / Math.abs(dx) 
            dy = if dy == 0 then dy else dy / Math.abs(dy) 
            @person.x += dx
            @person.y += dy
    
    Person = 
        init: () ->
            if @race not in ["human"] 
                console.log "Error. Unknown person type!"
                return
            @sprite_settings = sprites.persons[@race].yellow.walking.right
            
            sprite = @core.display.sprite( @sprite_settings )
            @addChild(sprite);
            
            @mission = SimpleMovement.create(this,500,400)
            
        draw: () ->
            # update
        
        setTileXY: (x,y) ->
            @x = x * @ship.tile_size + @ship.tile_offset.x
            @y = y * @ship.tile_size + @ship.tile_offset.x
            
        moveToXY: (x,y) ->
            @move_to = {x:x,y:y}
        
        moveToTileXY: (x,y) ->
            @move_to = {x:x,y:y}
        
        update: () ->
            @mission.update() 
            
    
    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.person = oCanvas.modules.display.person.setCore(init.canvas)
    
)
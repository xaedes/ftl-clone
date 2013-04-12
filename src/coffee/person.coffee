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
            
    
    SimpleTileMovement =
        # Handles movement of a person
        create: (person, x, y) ->
            return oCanvas.extend({person:person,x:x,y:y},SimpleTileMovement)
        
        update: () ->
            # calculate actual deltas
            adx = @x - @person.tile_x
            ady = @y - @person.tile_y
            # normalize deltas
            ndx = if adx == 0 then adx else adx / Math.abs(adx)
            ndy = if ady == 0 then ady else ady / Math.abs(ady)
            # calculate deltas for movement
            dx = Math.min(@person.tilespeed * ndx, adx)
            dy = Math.min(@person.tilespeed * ndy, ady)
            # move
            @person.tile_x += dx
            @person.tile_y += dy
    
    Person = 
        init: () ->
            if @race not in ["human"] 
                console.log "Error. Unknown person type!"
                return
            @sprite_settings = sprites.persons[@race].yellow.walking.right
            
            @tilespeed = 1 / init.canvas.settings.fps
            
            sprite = @core.display.sprite( @sprite_settings )
            @addChild(sprite);
            
            @mission = SimpleMovement.create(this,500,400)
            
        draw: () ->
            # update
        
        setTileXY: (tx,ty) ->
            @x = tx * @ship.tile_size + @ship.tile_offset.x
            @y = ty * @ship.tile_size + @ship.tile_offset.y
            
        moveToXY: (x,y) ->
            @move_to = {x:x,y:y}
        
        moveToTileXY: (x,y) ->
            @mission = SimpleTileMovement.create(this,x,y)
            
        moveByTileXY: (dx,dy) ->
            @mission = SimpleTileMovement.create(this,@tile_x + dx,@tile_y + dy)
        
        update: () ->
            @mission.update()
            @setTileXY(@tile_x,@tile_y)
    
    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.person = oCanvas.modules.display.person.setCore(init.canvas)
    
)
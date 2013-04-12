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
            
    
    Math.sign = (x) ->
        if x == 0 then x else (if x < 0 then -1 else 1) 
    
    SimpleTileMovement =
        # Handles movement of a person
        create: (person, x, y) ->
            return oCanvas.extend({person:person,x:x,y:y},SimpleTileMovement)
        
        update: () ->
            
            # calculate actual deltas
            adx = @x - @person.tile_x
            ady = @y - @person.tile_y
            # normalize deltas
            ndx = Math.sign(adx)
            ndy = Math.sign(ady)
            # calculate deltas for movement
            dx = Math.min(@person.tilespeed * ndx, adx)
            dy = Math.min(@person.tilespeed * ndy, ady)
            # move
            @person.tile_x += dx
            @person.tile_y += dy
            
            # activate correct walking animation
            if (dx > 0) and (dy == 0)
                sprite = @person.sprites.yellow.walking.right
            if (dx < 0) and (dy == 0)
                sprite = @person.sprites.yellow.walking.left
                
            if (dx == 0) and (dy < 0)
                sprite = @person.sprites.yellow.walking.up
            if (dx == 0) and (dy > 0)
                sprite = @person.sprites.yellow.walking.down
                
            @person.setSprite(sprite) if sprite?
    
    Person = 
        init: () ->
            if @race not in ["human"] 
                console.log "Error. Unknown person type!"
                return
            
            # One tile per second
            @tilespeed = 1 / init.canvas.settings.fps
            
            @active_sprite = null
            
            instantiate = (obj) ->
                newObj = {}
                for i of obj
                    if obj.hasOwnProperty(i)
                        if obj[i].hasOwnProperty("image")
                            newObj[i] = init.canvas.display.sprite(obj[i])
                        else
                        	newObj[i] = instantiate(obj[i])
                
                return newObj
            
            @sprites = instantiate(sprites.persons[@race])
                
            @setSprite(@sprites.yellow.walking.left)
            
            @mission = SimpleMovement.create(this,500,400)
        
        setSprite: (sprite) ->
            if @active_sprite == sprite
                return
            @removeChild(@active_sprite) if @active_sprite?
            @active_sprite = sprite
            @addChild(@active_sprite)
        
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
            if @lock 
               return
               
            @lock = true
            @mission.update()
            @setTileXY(@tile_x,@tile_y)
            
            @lock = false

    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend(Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.person = oCanvas.modules.display.person.setCore(init.canvas)
    
)
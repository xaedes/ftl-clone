define(["init","sprite_settings","container"], (init,sprites,Container) ->
    
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
        if x == 0 then 0 else (if x < 0 then -1 else 1) 
    
    directions=
        "-1":
            "-1": "left"
            "0": "left"
            "1": "left"
        "0":
            "-1": "up"
            "0": null
            "1": "down"
        "1":
            "-1": "right"
            "0": "right"
            "1": "right"
    
    SimpleTileMovement =
        # Handles movement of a person
        create: (person, x, y) ->
            return oCanvas.extend({person:person,x:x,y:y},SimpleTileMovement)
        
        update: () ->
            # calculate actual deltas
            adx = @x - @person.tile_x
            ady = @y - @person.tile_y
            
            if (adx == 0) and (ady == 0)
                @finished()
            
            # normalize deltas
            ndx = Math.sign(adx)
            ndy = Math.sign(ady)
            # calculate deltas for movement
            dx = Math.min(@person.tilespeed, Math.abs(adx) ) * ndx # go maximal the actual difference, not more
            dy = Math.min(@person.tilespeed, Math.abs(ady) ) * ndy 
            # move
            @person.tile_x += dx
            @person.tile_y += dy
            
            # activate correct walking animation
            direction = directions[ndx][ndy]
            @person.sprite.direction = direction if direction?
            @person.sprite.update()
        
        finished: () ->
            @person.sprite.direction = "down"
            @person.sprite.update()
    
    Person = 
        init: () ->
            if @race not in ["human","crystal","engi","energy","female","mantis","rock","slug"]
                console.log "Error. Unknown person type!"
                return
            

            
            # One tile per second
            @tilespeed = 1 / init.canvas.settings.fps
            
            @sprite_container = init.canvas.display.container(
                x: 0
                y: 0
            )
            @addChild(@sprite_container)
            
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
                
            @sprite = 
                color: "yellow"
                action: "walking"
                direction: "left"
                update: () =>
                    @setSprite(@sprites[@sprite.color][@sprite.action][@sprite.direction])
                
            @sprite.update()
            
            @selection_area = init.canvas.display.container(
                width: 16
                height: 16
                x: (35-16)/2
                y: (35-16)/2
            )
            @addChild(@selection_area)            
            @selection_area.bind("mouseenter", () =>
                init.canvas.mouse.cursor("pointer")
                @sprite.color="highlight" if this != @ship.selected_person
                @sprite.update()
            ).bind("mouseleave",()=>
                init.canvas.mouse.cursor("default")
                @sprite.color="yellow" if this != @ship.selected_person
                @sprite.update()
            )
            
            
        setSprite: (sprite) ->
            if @active_sprite == sprite
                return
            @sprite_container.removeChild(@active_sprite) if @active_sprite?
            @active_sprite = sprite
            @sprite_container.addChild(@active_sprite)
        
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
            @mission.update() if @mission?
            @setTileXY(@tile_x,@tile_y)
            
            @lock = false
        
        bind: (types, handler) ->
            @selection_area.bind(types, handler)
            
        unbind: (types, handler) ->
            @selection_area.unbind(types, handler)

    
    personObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend({}, Person, settings)

    oCanvas.registerDisplayObject("person", personObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.person = oCanvas.modules.display.person.setCore(init.canvas)
    
)
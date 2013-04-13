define(["math","init","sprite_settings","container","person_ki"], \
        (Math, init,sprites,Container,KI) ->
            
            
    Person = 
        selectable: true
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
                if @selectable
                    init.canvas.mouse.cursor("pointer")
                    @sprite.color="highlight" if this != @ship.selected_person
                    @sprite.update()
            ).bind("mouseleave",()=>
                if @selectable
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
            @mission = KI.SimpleTileMovement.create(this,x,y)
            
        moveByTileXY: (dx,dy) ->
            @mission = KI.SimpleTileMovement.create(this,@tile_x + dx,@tile_y + dy)
        
        update: () ->
            @lock = true
            @mission.update() if @mission?
            @setTileXY(@tile_x,@tile_y)
            

        
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
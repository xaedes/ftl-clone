define([], () -> 
    directions =
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
    KI={}
    KI.SimpleTileMovement =
        # Handles movement of a person
        create: (person, x, y) ->
            return oCanvas.extend({person:person,x:x,y:y},KI.SimpleTileMovement)
        
        update: () ->
            # calculate actual deltas
            adx = @x - @person.tile_x
            ady = @y - @person.tile_y
            
            if (adx == 0) and (ady == 0)
                @finished()
                return
            
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
        
    KI.RandomWalker =
        # Lets a person randomly walk
        create: (person) ->
            return oCanvas.extend({person:person},KI.RandomWalker)
        
        new_dest: () ->
            rx = (Math.random()*2-1)*2
            ry = (Math.random()*2-1)*2
            x = Math.round(Math.clip(@person.tile_x+rx,0,10))
            y = Math.round(Math.clip(@person.tile_y+ry,0,10))
            @mission = KI.SimpleTileMovement.create(@person,x,y)
            @mission.finished = () =>
                @new_dest()
        
        update: () ->
            if not @mission?
                @new_dest()
                
            @mission.update()
    
    return KI
)

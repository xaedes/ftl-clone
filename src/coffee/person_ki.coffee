define(["math"], (Math) -> 
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
    class SimpleTileMovement
        # Handles movement of a person
        constructor: (@person, @x, @y) ->
            @person.sprite.action = "walking"
            @person.sprite.update()
            
        update: (elapsedTime) ->
            # calculate actual deltas
            adx = @x - @person.attrs.tile_x
            ady = @y - @person.attrs.tile_y
            
            if (adx == 0) and (ady == 0)
                @finished()
                return
            
            # normalize deltas
            ndx = Math.sign(adx)
            ndy = Math.sign(ady)
            # calculate deltas for movement
            dx = Math.min(@person.attrs.tile_speed * elapsedTime, Math.abs(adx) ) * ndx # go maximal the actual difference, not more
            dy = Math.min(@person.attrs.tile_speed * elapsedTime, Math.abs(ady) ) * ndy 
            # move
            @person.attrs.tile_x += dx
            @person.attrs.tile_y += dy
            
            # activate correct walking animation
            direction = directions[ndx][ndy]
            @person.sprite.direction = direction if direction?
            @person.sprite.update()
        
        finished: () ->
            @person.sprite.direction = "down"
            @person.sprite.action = "standing"
            @person.sprite.update()
    KI.SimpleTileMovement = SimpleTileMovement
    class RandomWalker
        # Lets a person randomly walk
        constructor: (@person) ->
        
        new_dest: () ->
            rx = (Math.random()*2-1)*2
            ry = (Math.random()*2-1)*2
            x = Math.round(Math.clip(@person.attrs.tile_x+rx,6,9))
            y = Math.round(Math.clip(@person.attrs.tile_y+ry,1,4))
            @mission = new KI.SimpleTileMovement(@person,x,y)
            @mission.finished = () =>
                @person.sprite.action = "standing"
                @person.sprite.update()
                @mission.finished = () ->
                    return
                window.setTimeout(()=>
                    @new_dest()
                ,Math.round(1000-250+500*Math.random()))
        
        update: (elapsedTime) ->
            if not @mission?
                @new_dest()
                
            @mission.update(elapsedTime)

    KI.RandomWalker = RandomWalker
    return KI
)

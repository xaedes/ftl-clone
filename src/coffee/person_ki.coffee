define(["math","datastructures/priority_queue","datastructures/set"], (Math,PriorityQueue,Set) -> 
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
    KI = {}

    class KIBase
        eventListeners: []

        on: (eventsStr, handler) -> 
            events = eventsStr.split(' ')
            for event in events
                @eventListeners[event] = [] if not @eventListeners[event]?
                @eventListeners[event].push(
                    handler: handler)

        fire: (event, evtObj) ->
            evtObj = evtObj || {}
            for eventListener in @eventListeners[event]
                eventListener.handler.apply(this, [evtObj])



    class SimpleTileMovement extends KIBase
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
                @cancel_callback() if @cancel_callback?
                
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

        cancel: (callback) ->
            @cancel_callback = callback
            


    KI.SimpleTileMovement = SimpleTileMovement

    AStar = (person, x, y) ->
            # calculate path to destination
            # returns an array of positions with the goal beginning
            
            compare = (a,b) =>
                if a.cost_f < a.cost_f
                    return -1
                else if a.cost_f > a.cost_f
                    return 1
                else
                    return 0
            equality = (a,b) =>
                if a.x==b.x && a.y==b.y
                    return true
                else
                    return false

            goal = 
                x: x
                y: y

            distance = (pos) =>
                return Math.sqrt((goal.x-pos.x)*(goal.x-pos.x)+(goal.y-pos.y)*(goal.y-pos.y))

            tiles = new Array(person.ship.tiles.w)
            tiles.w = person.ship.tiles.w
            tiles.h = person.ship.tiles.h
            for x in [0..tiles.w-1]
                tiles[x] = new Array(tiles.h)
                # for y in [0..tiles.h-1]
                #     tiles[x][y] = 

            startTile = 
                x: Math.round(person.attrs.tile_x)
                y: Math.round(person.attrs.tile_y)

            startTile.cost = 0
            startTile.cost_f = distance(startTile)



            openlist = new PriorityQueue("cost_f")
            closedlist = new Set(equality)

            openlist.enqueue(startTile)
            loop
                current = openlist.dequeue()
                if equality(current, goal)
                    # Path found

                    path = []
                    path.push(current)
                    while current.predecessor?
                        current = current.predecessor 
                        path.push(current)
                    path.pop() # remove start tile

                    return path

                closedlist.add(current)

                # expand 

                neighbors = person.ship.getWalkableNeighbors(current.x, current.y)
                for neighbor in neighbors
                    if closedlist.contains(neighbor)
                        # Already best path to this neighbor found
                        continue

                    # cost so far (g value)
                    cost = current.cost + 1 


                    if tiles[neighbor.x][neighbor.y]? and cost >= tiles[neighbor.x][neighbor.y].cost
                        # Already in openlist with better path
                        continue

                    if tiles[neighbor.x][neighbor.y]?
                        neighbor = tiles[neighbor.x][neighbor.y]
                    else
                        tiles[neighbor.x][neighbor.y] = neighbor

                    neighbor.predecessor = current
                    neighbor.cost = cost
                    neighbor.cost_f = cost + distance(neighbor)

                    if openlist.contains(neighbor, equality)
                        openlist.keyChanged(neighbor)
                    else
                        openlist.enqueue(neighbor)


                break if openlist.isEmpty()

            return []

    class TileMovement extends KIBase
        constructor: (@person, @x, @y) ->
            @reversePath = AStar(@person,@x,@y)

        next_step: () ->
            @cancel_callback() if @cancel_callback?

            if @reversePath.length
                @next = @reversePath.pop()

                # add sub mission to reach next tile
                @mission = new KI.SimpleTileMovement(@person,@next.x,@next.y)

                # check if there is a door between here and the next tile
                id1 = @person.ship.tiles[Math.round(@person.attrs.tile_x)][Math.round(@person.attrs.tile_y)].room_id
                id2 = @person.ship.tiles[@next.x][@next.y].room_id
                if id1 != id2 # not the same room
                    @mission.door = @person.ship.tiles[@next.x][@next.y].reachable_rooms[id1]
                    if not @mission.door.isWalkable()
                        @mission.door.toggleState()
                        @mission.close_door = true



                
                # if there are more tiles to reach set callback to do the next step when current sub mission is finished
                if @reversePath.length > 0

                    @mission.finished = () =>
                        if @mission.close_door
                            @mission.door.toggleState()
                            delete @mission.door
                            delete @mission.close_door
                        @next_step()
                else
                    @mission.finished = () =>
                        if @mission.close_door
                            @mission.door.toggleState()
                            delete @mission.door
                            delete @mission.close_door
                        @finished()
            else
                @finished()

        update: (elapsedTime) ->
            # calculate actual deltas
            if not @mission?
                @next_step()

            @mission.update(elapsedTime) if @mission?
        
        finished: () ->
            @person.sprite.direction = "down"
            @person.sprite.action = "standing"
            @person.sprite.update()

        cancel: (callback) ->
            @cancel_callback = callback
            @mission.cancel(callback) if @mission

    KI.TileMovement = TileMovement


    class RandomWalker extends KIBase
        # Lets a person randomly walk
        constructor: (@person) ->
        
        new_dest: () ->
            rx = (Math.random()*2-1)*2
            ry = (Math.random()*2-1)*2
            x = Math.round(Math.clip(@person.attrs.tile_x+rx,6,9))
            y = Math.round(Math.clip(@person.attrs.tile_y+ry,1,4))
            @mission = new KI.TileMovement(@person,x,y)
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

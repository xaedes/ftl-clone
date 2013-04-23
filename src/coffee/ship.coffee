define(["init","animations","assets","person_ki","ship_data", "door"]
      ,(init,animations,Assets,PersonKI,ship_data,Door) ->


    class Ship extends Kinetic.Group
        persons: []
        constructor: (config) ->
            @attrs = 
                ship: "kestral"

            Kinetic.Group.call(@, config) #Call super constructor

            # Put ship data in @
            @data = ship_data[@attrs.ship]

            @initRooms()


            @attrs.layer.add(@)
            
            floor = new Kinetic.Image( 
                image: animations.ships[@attrs.ship].floor.image 
            )
            base = new Kinetic.Image( 
                image: animations.ships[@attrs.ship].base.image
            )
            
            @backgroundGroup = new Kinetic.Group({})
            @backgroundGroup.add(base)
            @backgroundGroup.add(floor)

            @doorsGroup = new Kinetic.Group({})

            @personsGroup = new Kinetic.Group({})

            
            @add(@backgroundGroup)
            @add(@doorsGroup)
            @add(@personsGroup)

            @initDoors()
            
            @on("click tap",(event) => 
                event.stopPropagation()
                if @selected_person?
                    switch event.which
                        when 1 # left click
                            @deselectPerson()
                        when 3 # right click
                            absPos = @getAbsolutePosition()
                            tile_pos = @calculateTileXY(event.layerX - absPos.x, event.layerY - absPos.y)
                            if (tile_pos.x >= 0) and (tile_pos.y >= 0) and (tile_pos.x < @tiles.w) and (tile_pos.y < @tiles.h)
                                if @tiles[tile_pos.x][tile_pos.y].room_id?
                                    @selected_person.mission = new PersonKI.TileMovement(@selected_person,tile_pos.x,tile_pos.y)
            )
        
        initRooms: () ->
            maxW = 0
            maxH = 0
            for room in @data.rooms
                maxW = Math.max(maxW,room.x+room.w)
                maxH = Math.max(maxH,room.y+room.h)
            for door in @data.doors
                maxW = Math.max(maxW,door.x+1)
                maxH = Math.max(maxH,door.y+1)

            @tiles = new Array(maxW)
            @tiles.w = maxW
            @tiles.h = maxH
            for x in [0..maxW-1]
                @tiles[x] = new Array(maxH-1)
                for y in [0..maxH-1]
                    @tiles[x][y] = 
                        reachable_rooms: []

            for room in @data.rooms
                for x in [0..room.w-1]
                    for y in [0..room.h-1]
                        @tiles[x+room.x][y+room.y].room_id = room.id

        initDoors: () ->
            @doors = []
            for doorData in @data.doors
                # set reachability of rooms
                if @tiles[doorData.x][doorData.y].room_id == doorData.id1
                    # sometimes the ids are swapped
                    # make sure id1 contains the room that is reachable from @tiles[doorData.x][doorData.y]
                    tmp = doorData.id1
                    doorData.id1 = doorData.id2
                    doorData.id2 = tmp

                @tiles[doorData.x][doorData.y].reachable_rooms = @tiles[doorData.x][doorData.y].reachable_rooms || []
                @tiles[doorData.x][doorData.y].reachable_rooms.push(doorData.id1)
                if doorData.direction == 0 # up
                    if doorData.y-1 >= 0
                        @tiles[doorData.x][doorData.y-1].reachable_rooms = @tiles[doorData.x][doorData.y-1].reachable_rooms || []
                        @tiles[doorData.x][doorData.y-1].reachable_rooms.push(doorData.id2)
                else # left
                    if doorData.x-1 >= 0
                        @tiles[doorData.x-1][doorData.y].reachable_rooms = @tiles[doorData.x-1][doorData.y].reachable_rooms || []
                        @tiles[doorData.x-1][doorData.y].reachable_rooms.push(doorData.id2)

                # create door object
                door = new Door
                    ship: @
                    data: doorData

                @doorsGroup.add(door)


        getWalkableNeighbors: (x,y) ->
            # gets a list of tile positions that can be reached from (x,y) in one walking step
            neighbors = []
            for dx in [-1..1]
                if (x+dx >= 0) and (x+dx < @tiles.w)
                    for dy in [-1..1]
                        if (y+dy >= 0) and (y+dy < @tiles.h)
                            if dx == dy and dx == 0
                                continue
                            if @tiles[x+dx][y+dy].room_id?
                                if (dx * dy == 0) # horizontal or vertical 
                                    if @tiles[x][y].room_id == @tiles[x+dx][y+dy].room_id # in same room without door allowed
                                        neighbors.push({x:dx+x,y:dy+y})
                                    else if (@tiles[x+dx][y+dy].room_id in @tiles[x][y].reachable_rooms) or (@tiles[x][y].room_id in @tiles[x+dx][y+dy].reachable_rooms)
                                        neighbors.push({x:dx+x,y:dy+y})
                                else if @tiles[x][y].room_id == @tiles[x+dx][y+dy].room_id # diagonal only allowed in same room
                                    neighbors.push({x:dx+x,y:dy+y})

            return neighbors


        calculateTileXY: (x,y,precision=false) ->
            tile_pos = 
                x: (x + @data.tile_offset.x) / @data.tile_size
                y: (y + @data.tile_offset.y) / @data.tile_size
            if not precision
                tile_pos.x = Math.floor(tile_pos.x)
                tile_pos.y = Math.floor(tile_pos.y)
            return tile_pos
        
        selectPerson: (person) ->
            if not person.attrs.selectable?
                return
            @deselectPerson()
            @selected_person = person
            @selected_person.attrs.selected = true
            @selected_person.sprite.color = "green"
            @selected_person.sprite.update()
            
        deselectPerson: () ->
            if @selected_person?
                @selected_person.attrs.selected = false
                @selected_person.sprite.color = "yellow"
                @selected_person.sprite.update()
            @selected_person = null
            
        addPerson: (person) ->
            person.ship = this
            @personsGroup.add(person)
            person.selectionArea.on("click",(event) =>
                switch event.which
                    when 1 # left click
                        if person.attrs.selectable
                            @selectPerson(person)
                            event.cancelBubble = true
            )
            person.sprite.update()
            @persons.push(person)

        update: (elapsedTime) ->
            for person in @persons
                person.update(elapsedTime)
    
    return Ship
    
)
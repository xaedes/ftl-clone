define(["init","animations","assets","person_ki","ship_data", "door", "room", "multi_layer_group"]
      ,(init,animations,Assets,PersonKI,ship_data,Door,Room,MultiLayerGroup) ->


    class Ship extends MultiLayerGroup
        persons: []
        constructor: (config) ->
            @attrs = 
                ship: "kestral"

            super(config) #Call super constructor
            # Kinetic.Group.call(@, config) #Call super constructor

            # Put ship data in @
            @data = ship_data[@attrs.ship]

            # @layers.ship.add(@)

            
            if animations.ships[@attrs.ship].floor?
                floor = new Kinetic.Image( 
                    image: animations.ships[@attrs.ship].floor.image 
                )
            base = new Kinetic.Image( 
                image: animations.ships[@attrs.ship].base.image
            )
            
            @backgroundGroup = new Kinetic.Group({})
            @backgroundGroup.add(base)
            @backgroundGroup.add(floor) if floor?

            @doorsGroup = new Kinetic.Group({})

            @roomsGroup = new Kinetic.Group({})

            @personsGroup = new Kinetic.Group({})

            
            @layers.ship.add(@backgroundGroup)
            @layers.ship.add(@roomsGroup)
            @layers.ship.add(@doorsGroup)
            @layers.persons.add(@personsGroup)

            @initRoomsAndDoors()
            
            @layers.ship.on("click tap",(event) => 
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
        
        initRoomsAndDoors: () ->
            maxW = 0
            maxH = 0
            for room in @data.rooms
                maxW = Math.max(maxW,room.x+room.w)
                maxH = Math.max(maxH,room.y+room.h)
            for door in @data.doors
                maxW = Math.max(maxW,door.x+1)
                maxH = Math.max(maxH,door.y+1)

            # Initialize tiles
            @tiles = new Array(maxW)
            @tiles.w = maxW
            @tiles.h = maxH
            for x in [0..maxW-1]
                @tiles[x] = new Array(maxH-1)
                for y in [0..maxH-1]
                    @tiles[x][y] = 
                        reachable_rooms: []
                        open: []

            # Set room assignments
            for roomData in @data.rooms
                for x in [0..roomData.w-1]
                    for y in [0..roomData.h-1]
                        @tiles[x+roomData.x][y+roomData.y].room_id = roomData.id


            # Set reachability of rooms via doors
            @doors = []
            for doorData in @data.doors
                if @tiles[doorData.x][doorData.y].room_id == doorData.id1
                    # sometimes the ids are swapped
                    # make sure id1 contains the room that is reachable from @tiles[doorData.x][doorData.y]
                    tmp = doorData.id1
                    doorData.id1 = doorData.id2
                    doorData.id2 = tmp

                @tiles[doorData.x][doorData.y].reachable_rooms = @tiles[doorData.x][doorData.y].reachable_rooms || []
                @tiles[doorData.x][doorData.y].reachable_rooms.push(doorData.id1)
                if doorData.direction == 0 # up
                    @tiles[doorData.x][doorData.y].open.push("up")
                    if doorData.y-1 >= 0
                        @tiles[doorData.x][doorData.y-1].open.push("down")
                        @tiles[doorData.x][doorData.y-1].reachable_rooms = @tiles[doorData.x][doorData.y-1].reachable_rooms || []
                        @tiles[doorData.x][doorData.y-1].reachable_rooms.push(doorData.id2)
                else # left
                    @tiles[doorData.x][doorData.y].open.push("left")
                    if doorData.x-1 >= 0
                        @tiles[doorData.x-1][doorData.y].open.push("right")
                        @tiles[doorData.x-1][doorData.y].reachable_rooms = @tiles[doorData.x-1][doorData.y].reachable_rooms || []
                        @tiles[doorData.x-1][doorData.y].reachable_rooms.push(doorData.id2)


            # Create door objects
            for doorData in @data.doors
                door = new Door
                    ship: @
                    data: doorData

                @doorsGroup.add(door)

            # Create room objects
            for roomData in @data.rooms
                room = new Room(
                    data: roomData
                    ship: @
                )
                @roomsGroup.add(room)



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
                                # else if @tiles[x][y].room_id == @tiles[x+dx][y+dy].room_id # diagonal only allowed in same room
                                    # neighbors.push({x:dx+x,y:dy+y})

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
define(["multi_layer_container"],(MultiLayerContainer)->

	class Room extends MultiLayerContainer
		constructor: (config) ->
            # Default attrs
            @attrs = 
                selectable: true

            #Call super constructor
            super(config)
            # Kinetic.Group.call(@, config) 
            
            @data = @attrs.data
           	@ship = @attrs.ship

            @setX( @data.x * @ship.data.tile_size - @ship.data.tile_offset.x - 1.0 ) 
            @setY( @data.y * @ship.data.tile_size - @ship.data.tile_offset.y - 1.0 ) 

            bg = new Kinetic.Rect(
                width: @data.w * @ship.data.tile_size
                height: @data.h * @ship.data.tile_size
                fillEnabled: true
                strokeEnabled: false
                fill: "#E4E2D8"
                layer: "ships"
            )
            @add(bg)
            
            @backgroundGridGroup = new Kinetic.Group(
                layer: "ships"
            )
            @wallGroup = new Kinetic.Group(
                layer: "ships"
            )
            
            @add(@backgroundGridGroup)
            @add(@wallGroup)

            @addLines()

            @selectionArea = new Kinetic.Rect(
                width: @data.w * @ship.data.tile_size
                height: @data.h * @ship.data.tile_size
                layer: "room_selection_areas"
            )
            @add(@selectionArea)

        update: (elapsedTime) ->
        	# @sprite.start()

        addLines: () ->
            boundaryStrokeWidth = 2
            boundaryDoorStrokeWidth = 4
            backgroundGridStrokeWidth = 1
            doorWallLength = 4
            # draw lines
            for x in [0..@data.w-1]
                # vertical background grid lines
                if x>0
                    line = new Kinetic.Line(
                        points: [[x*@ship.data.tile_size,0],[x*@ship.data.tile_size,@data.h*@ship.data.tile_size]]
                        stroke: "#C6C4C0"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @backgroundGridGroup.add(line)

                # horizontal boundaries
                for where in [{open:"up",y:0},{open:"down",y:1}]
                    y = where.y*@data.h*@ship.data.tile_size
                    if where.open not in @ship.tiles[x+@data.x][@data.y+where.y*(@data.h-1)].open
                        if (
                            ((where.y == 0) and (@data.y == 0 or not @ship.tiles[@data.x+x][@data.y-1].room_id?)) or
                            ((where.y != 0) and (@data.y+@data.h-1 == @ship.tiles.h - 1 or not @ship.tiles[@data.x+x][@data.y+@data.h].room_id?))
                        )
                            # neighboring tile has no room
                            strokeWidth = boundaryStrokeWidth
                            lineCap = "square"
                        else
                            strokeWidth = boundaryDoorStrokeWidth
                            lineCap = "butt"
                            
                        # closed boundary
                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,y],[(x+1)*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: strokeWidth
                            lineCap: lineCap
                        )
                        @wallGroup.add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,y],[doorWallLength+x*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                        line = new Kinetic.Line(
                            points: [[(x+1)*@ship.data.tile_size,y],[-doorWallLength+(x+1)*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)


            for y in [0..@data.h-1]
                # horizontal background grid lines
                if y>0
                    line = new Kinetic.Line(
                        points: [[0,y*@ship.data.tile_size],[@data.w*@ship.data.tile_size,y*@ship.data.tile_size]]
                        stroke: "#C6C4C0"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @backgroundGridGroup.add(line)

                # vertical boundaries
                for where in [{open:"left",x:0},{open:"right",x:1}]
                    x = where.x*@data.w*@ship.data.tile_size
                    if where.open not in @ship.tiles[@data.x+where.x*(@data.w-1)][@data.y+y].open
                        if (
                            ((where.x == 0) and (@data.x == 0 or not @ship.tiles[@data.x-1][@data.y+y].room_id?) ) or
                            ((where.x != 0) and (@data.x+@data.w-1 == @ship.tiles.w - 1 or not @ship.tiles[@data.x+@data.w][@data.y+y].room_id?))
                        )
                            # neighboring tile has no room
                            strokeWidth = boundaryStrokeWidth
                            lineCap = "square"
                        else
                            strokeWidth = boundaryDoorStrokeWidth
                            lineCap = "butt"

                        line = new Kinetic.Line(
                            points: [[x,y*@ship.data.tile_size],[x,(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: strokeWidth
                            lineCap: lineCap
                        )
                        @wallGroup.add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[x,y*@ship.data.tile_size],[x,doorWallLength+y*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                        line = new Kinetic.Line(
                            points: [[x,(y+1)*@ship.data.tile_size],[x,-doorWallLength+(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)



            

	return Room

)
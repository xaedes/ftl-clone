define(["multi_layer_container","animations/ships"],(MultiLayerContainer,ships_images)->

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

            @setX( @data.x * @ship.data.tile_size - @ship.data.tile_offset.x  ) 
            @setY( @data.y * @ship.data.tile_size - @ship.data.tile_offset.y  ) 

            bg = new Kinetic.Rect(
                width: @data.w * @ship.data.tile_size
                height: @data.h * @ship.data.tile_size
                fillEnabled: true
                strokeEnabled: false
                fill: "#E4E2D8"
                layer: "ships"
            )
            @add(bg)

            if @data["system"]? and @data["system"]["start"] == "true"
                @addSystem()


            
            @backgroundGridGroup = new Kinetic.Group(
                layer: "ships"
            )
            @wallGroup = new Kinetic.Group(
                layer: "walls"
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

        addSystem: () ->
            if @data["system"]? and ships_images[@ship.attrs.ship][@data["system"]["name"]]?
                system = new Kinetic.Image(
                    image: ships_images[@ship.attrs.ship][@data["system"]["name"]]
                    layer: "interior"
                    # y: -1
                )
                @add(system)            

        update: (elapsedTime) ->
        	# @sprite.start()

        addLines: () ->
            backgroundGridStrokeWidth = 1
            boundaryStrokeWidth = 2
            doorWallLength = 4

            # tilesize = @ship.data.tile_size 

            # draw lines
            for x in [0..@data.w-1]
                # vertical background grid lines
                if x>0
                    line = new Kinetic.Line(
                        points: [[x*@ship.data.tile_size-0.5,0],[x*@ship.data.tile_size-0.5,@data.h*@ship.data.tile_size]]
                        stroke: "#C6C4C0"
                        # stroke: "black"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @backgroundGridGroup.add(line)

                # horizontal boundaries
                for where in [{open:"up",y:0},{open:"down",y:1}]
                    y = where.y*@data.h*@ship.data.tile_size
                    if where.y == 0
                        y += 1
                    else
                        y -= 1
                    if where.open not in @ship.tiles[x+@data.x][@data.y+where.y*(@data.h-1)].open
                        # closed boundary
                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,y],[(x+1)*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,y],[doorWallLength+x*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                        line = new Kinetic.Line(
                            points: [[(x+1)*@ship.data.tile_size,y],[-doorWallLength+(x+1)*@ship.data.tile_size,y]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)


            for y in [0..@data.h-1]
                # horizontal background grid lines
                if y>0
                    line = new Kinetic.Line(
                        points: [[0,y*@ship.data.tile_size-0.5],[@data.w*@ship.data.tile_size,y*@ship.data.tile_size-0.5]]
                        stroke: "#C6C4C0"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @backgroundGridGroup.add(line)

                # vertical boundaries
                for where in [{open:"left",x:0},{open:"right",x:1}]
                    x = where.x*@data.w*@ship.data.tile_size
                    if where.x == 0
                        x += 1
                    else
                        x -= 1
                    if where.open not in @ship.tiles[@data.x+where.x*(@data.w-1)][@data.y+y].open
                        line = new Kinetic.Line(
                            points: [[x,y*@ship.data.tile_size],[x,(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[x,y*@ship.data.tile_size],[x,doorWallLength+y*@ship.data.tile_size]]
                            stroke: "black" 
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)
                        line = new Kinetic.Line(
                            points: [[x,(y+1)*@ship.data.tile_size],[x,-doorWallLength+(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "butt"
                        )
                        @wallGroup.add(line)



            

	return Room

)
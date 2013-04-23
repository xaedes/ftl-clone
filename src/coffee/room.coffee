define([],()->

	class Room extends Kinetic.Group
		constructor: (config) ->
            @attrs = {}
            Kinetic.Group.call(@, config) #Call super constructor
            
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
            )
            @add(bg)

            @addLines()


        update: (elapsedTime) ->
        	# @sprite.start()

        addLines: () ->
            boundaryStrokeWidth = 2
            boundaryDoorStrokeWidth = 4
            backgroundGridStrokeWidth = 1
            # draw lines
            for x in [0..@data.w-1]
                # vertical background grid lines
                if x>0
                    line = new Kinetic.Line(
                        points: [[x*@ship.data.tile_size,0],[x*@ship.data.tile_size,@data.h*@ship.data.tile_size]]
                        stroke: "#C6C4C0"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @add(line)

                # horizontal boundaries
                for where in [{open:"up",y:0},{open:"down",y:1}]
                    if where.open not in @ship.tiles[x+@data.x][@data.y+where.y*(@data.h-1)].open
                        # closed boundary

                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size],[(x+1)*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[x*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size],[2+x*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)
                        line = new Kinetic.Line(
                            points: [[(x+1)*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size],[-2+(x+1)*@ship.data.tile_size,where.y*@data.h*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)


            for y in [0..@data.h-1]
                # horizontal background grid lines
                if y>0
                    line = new Kinetic.Line(
                        points: [[0,y*@ship.data.tile_size],[@data.w*@ship.data.tile_size,y*@ship.data.tile_size]]
                        stroke: "#C6C4C0"
                        strokeWidth: backgroundGridStrokeWidth
                    )
                    @add(line)

                # vertical boundaries
                for where in [{open:"left",x:0},{open:"right",x:1}]
                    if where.open not in @ship.tiles[@data.x+where.x*(@data.w-1)][@data.y+y].open
                        # closed boundary
                        line = new Kinetic.Line(
                            points: [[where.x*@data.w*@ship.data.tile_size,y*@ship.data.tile_size],[where.x*@data.w*@ship.data.tile_size,(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)
                    else
                        # door
                        line = new Kinetic.Line(
                            points: [[where.x*@data.w*@ship.data.tile_size,y*@ship.data.tile_size],[where.x*@data.w*@ship.data.tile_size,2+y*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)
                        line = new Kinetic.Line(
                            points: [[where.x*@data.w*@ship.data.tile_size,(y+1)*@ship.data.tile_size],[where.x*@data.w*@ship.data.tile_size,-2+(y+1)*@ship.data.tile_size]]
                            stroke: "black"
                            strokeWidth: boundaryDoorStrokeWidth
                            lineCap: "square"
                        )
                        @add(line)



            

	return Room

)
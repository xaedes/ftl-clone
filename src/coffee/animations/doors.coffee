define(["assets"], (Assets) ->

    
    

    doors = {}
    doors.doors = {}
    doors.doors.image = Assets.image("img/effects/door_sheet.png", "doors")
    doors.doors.animations = 
    	level1: ({
		    	x: x*35
		    	y: 0*35
		    	width: 35
		    	height: 35
		    } for x in [0..4])
    	level2: ({
		    	x: x*35
		    	y: 1*35
		    	width: 35
		    	height: 35
		    } for x in [0..4])
    	level3: ({
		    	x: x*35
		    	y: 2*35
		    	width: 35
		    	height: 35
		    } for x in [0..4])
    	none: [
    		x: 50
    		y: 0
    		width: 0
    		height: 0
    	]

    doors.highlight = {}
    doors.highlight.image = Assets.image("img/effects/door_highlight.png", "doors")
    
    return doors
)
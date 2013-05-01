define(["assets"], (Assets) ->

    
    

    doors = {}
    doors.doors = {}
    doors.doors.image = Assets.image("img/effects/door_sheet.png", "doors")
    doors.doors.animations = {}
    for k in [0,1,2]
        doors.doors.animations["level"+k+"_opening"] = ({
                x: x*35
                y: k*35
                width: 35
                height: 35
            } for x in [0..4].reverse())
        doors.doors.animations["level"+k+"_closing"] = ({
                x: x*35
                y: k*35
                width: 35
                height: 35
            } for x in [0..4])
        doors.doors.animations["level"+k+"_open"] = ({
                x: x*35
                y: k*35
                width: 35
                height: 35
            } for x in [0])
        doors.doors.animations["level"+k+"_closed"] = ({
                x: x*35
                y: k*35
                width: 35
                height: 35
            } for x in [4])



    doors.highlight = {}
    doors.highlight.image = Assets.image("img/effects/door_highlight.png", "doors")
    
    return doors
)
define(["init"], (init) ->
    

    console.log("human")

    class Human
        
        @sprite_walking_down: init.canvas.display.sprite({
            x: 177,
            y: 80,
            image: "img/people/human_player_yellow.png"
            width: 35,
            height: 35,
            generate: true,
            direction: "x",
            numFrames: 4,
            duration: 250,
            autostart: true
        })
        
#        @sprite_walking_right: Human.sprite_walking_down({
#            offset_x: 4*35
#        })
#        @sprite_walking_up: @sprite_walking_down({
#            offset_x: 2*4*35
#        })
#        @sprite_walking_left: @sprite_walking_down({
#            offset_x: 3*4*35
#        })
        
        constructor: () -> 
           console.log "ok"
    
    oCanvas.extend(Human,oCanvas.core)
    
    return Human
)
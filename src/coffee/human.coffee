define([], () ->
    
    class Human
        constructor: (@canvas) -> 
            @sprite_walking_down = @canvas.display.sprite({
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
            
            @sprite_walking_right = @sprite_walking_down.clone({
                offset_x: 4*35
            })
            @sprite_walking_up = @sprite_walking_down.clone({
                offset_x: 2*4*35
            })
            @sprite_walking_left = @sprite_walking_down.clone({
                offset_x: 3*4*35
            })
            
            human = this
            
            @sprite_walking_down.bind("click tap",()->
                human.removeFromCanvas()
                human.active = human.sprite_walking_up
                human.addToCanvas()
            )
            @sprite_walking_up.bind("click tap",()->
                human.removeFromCanvas()
                human.active = human.sprite_walking_down
                human.addToCanvas()
            )
            
            @active = @sprite_walking_down

        addToCanvas: () ->
            @canvas.addChild(@active)
        
        removeFromCanvas: () ->
            @canvas.removeChild(@active)
        	
        
        
    return Human
)
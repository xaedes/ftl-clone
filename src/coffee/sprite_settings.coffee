define([""], () ->
    
    peopleSprites = (race) ->
        if race not in ["human"] 
            return
        
        sprites = {
            yellow : {
                walking: {
                    down: {
                        x: 0,
                        y: 0,
                        image: "img/people/"+race+"_player_yellow.png",
                        width: 35,
                        height: 35,
                        generate: true,
                        direction: "x",
                        numFrames: 4,
                        duration: 250,
                        autostart: true
                    }
                }
            }
        }
        sprites.yellow.walking.right = oCanvas.extend({offset_x:4*35}, sprites.yellow.walking.down)
        sprites.yellow.walking.up = oCanvas.extend({offset_x:2*4*35}, sprites.yellow.walking.down)
        sprites.yellow.walking.left = oCanvas.extend({offset_x:4*4*35}, sprites.yellow.walking.down)
        
        return sprites
        
#    HumanSprites = {
#        normal_down: {
#            x: 0,
#            y: 0,
#            image: "img/people/human_player_yellow.png"
#            width: 35,
#            height: 35,
#            generate: true,
#            direction: "x",
#            numFrames: 4,
#            duration: 250,
#            autostart: true
#        }
#    }
#        
#    HumanSprites.normal_right = oCanvas.extend({offset_x:4*35}, HumanSprites.normal_down)
#    HumanSprites.normal_up = oCanvas.extend({offset_x:2*4*35}, HumanSprites.normal_down)
#    HumanSprites.normal_left = oCanvas.extend({offset_x:4*4*35}, HumanSprites.normal_down)

    return {human: peopleSprites("human")}
)
define([""], () ->
    
    peopleSprites = (race) ->
        if race not in ["human"] 
            return
        
        peopleBase = {
            width: 35,
            height: 35,
            generate: true,
            direction: "x",
            numFrames: 4,
            duration: 250,
            autostart: true
        }
        
        sprites = {
            yellow: {
                walking: {},
                extinguish_fire: {},
            }
        }
        sprites.yellow.walking.down = oCanvas.extend({image: "img/people/"+race+"_player_yellow.png"},peopleBase)
        sprites.yellow.walking.right = oCanvas.extend({offset_x:1*4*35}, sprites.yellow.walking.down)
        sprites.yellow.walking.up = oCanvas.extend({offset_x:2*4*35}, sprites.yellow.walking.down)
        sprites.yellow.walking.left = oCanvas.extend({offset_x:4*4*35}, sprites.yellow.walking.down)
        
        sprites.yellow.extinguish_fire.down = oCanvas.extend({
            image: "img/people/"+race+"_player_yellow.png",
            offset_y: 3*35
        },peopleBase)
        sprites.yellow.extinguish_fire.right = oCanvas.extend({offset_x:1*4*35}, sprites.yellow.extinguish_fire.down)
        sprites.yellow.extinguish_fire.up = oCanvas.extend({offset_x:2*4*35}, sprites.yellow.extinguish_fire.down)
        sprites.yellow.extinguish_fire.left = oCanvas.extend({offset_x:4*4*35}, sprites.yellow.extinguish_fire.down)
        
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
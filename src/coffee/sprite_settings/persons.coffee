define([""], () ->
    personsSprites = (race) ->
        if race not in ["human"] 
            return
        
        personBase = {
            width: 35,
            height: 35,
            generate: true,
            direction: "x",
            numFrames: 4,
            duration: 250,
            autostart: true
        }
        
        colors = ["yellow","highlight","red","green"]
        
        sprites = {}
        for color in colors
            sprites[color] = {
                walking: {},
                extinguish_fire: {},
            }
            filename = race+"_"+(if color != "red" then "player" else "enemy")+"_"+color
            
            sprites[color].walking.down = oCanvas.extend({image: "img/people/"+filename+".png"},personBase)
            sprites[color].walking.right = oCanvas.extend({offset_x:1*4*35}, sprites[color].walking.down)
            sprites[color].walking.up = oCanvas.extend({offset_x:2*4*35}, sprites[color].walking.down)
            sprites[color].walking.left = oCanvas.extend({offset_x:4*4*35}, sprites[color].walking.down)
            
#            sprites[color].extinguish_fire.down = oCanvas.extend({
#                image: "img/people/"+filename+".png",
#                offset_y: 3*35
#            },peopleBase)
#            sprites[color].extinguish_fire.right = oCanvas.extend({offset_x:1*4*35}, sprites[color].extinguish_fire.down)
#            sprites[color].extinguish_fire.up = oCanvas.extend({offset_x:2*4*35}, sprites[color].extinguish_fire.down)
#            sprites[color].extinguish_fire.left = oCanvas.extend({offset_x:4*4*35}, sprites[color].extinguish_fire.down)
            
            
        return sprites
    
    return {human: personsSprites("human")}
)
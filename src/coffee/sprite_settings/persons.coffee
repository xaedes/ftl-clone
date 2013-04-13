define([""], () ->
    races = ["human","crystal","engi","energy","female","mantis","rock","slug"]
    
    # FIXME mantis sprites differs from the others :/
    
    personsSprites = (race) ->
        if race not in races 
            return
        
        base = 
            generate: true
            width: 35
            height: 35
            numFrames: 1
        
        animated =
            direction: "x"
            numFrames: 4
            duration: 250
            autostart: true
        
        colors = ["yellow","highlight","red","green"]
        
        sprites = {}
        for color in colors
            sprites[color] = 
                standing: {}
                walking: {}
                extinguish_fire: {}
            
            filename = race+"_"+(if color != "red" then "player" else "enemy")+"_"+color
            
            
            sprites[color].standing.down = oCanvas.extend({image: "img/people/"+filename+".png"},base)
            sprites[color].standing.right = oCanvas.extend({offset_x:1*4*35}, sprites[color].standing.down)
            sprites[color].standing.up = oCanvas.extend({offset_x:2*4*35}, sprites[color].standing.down)
            sprites[color].standing.left = oCanvas.extend({offset_x:3*4*35}, sprites[color].standing.down)
            
            sprites[color].walking.down = oCanvas.extend({image: "img/people/"+filename+".png"},base,animated)
            sprites[color].walking.right = oCanvas.extend({offset_x:1*4*35}, sprites[color].walking.down)
            sprites[color].walking.up = oCanvas.extend({offset_x:2*4*35}, sprites[color].walking.down)
            sprites[color].walking.left = oCanvas.extend({offset_x:3*4*35}, sprites[color].walking.down)
            
            sprites[color].extinguish_fire.down = oCanvas.extend(
                image: "img/people/"+filename+".png"
                offset_y: 3*35
            ,base,animated)
            sprites[color].extinguish_fire.right = oCanvas.extend({offset_x:1*4*35}, sprites[color].extinguish_fire.down)
            sprites[color].extinguish_fire.up = oCanvas.extend({offset_x:2*4*35}, sprites[color].extinguish_fire.down)
            sprites[color].extinguish_fire.left = oCanvas.extend({offset_x:3*4*35}, sprites[color].extinguish_fire.down)
            
            
        return sprites
    sprites = {}
    for race in races
    	sprites[race] = personsSprites(race)
    
    return sprites
)
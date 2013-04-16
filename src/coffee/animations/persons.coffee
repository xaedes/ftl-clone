define(["utils"], (Utils) ->
    races = ["human","crystal","engi","energy","female","mantis","rock","slug"]
    
    # FIXME mantis animations differs from the others :/
    
    personsAnimations = (race) ->
        if race not in races 
            return
        
        size = 
            width: 35
            height: 35

        
        colors = ["yellow","highlight","red","green"]
        
        animations = {}
        for color in colors
            animations[color] = {}
            
            # "img/people/"+filename+".png"
            filename = race+"_"+(if color != "red" then "player" else "enemy")+"_"+color
            
            genDirections = (y,numFrames = 4, animated = true) ->
                range = if animated then [0..numFrames-1] else [0]
                return {
                    down:  (Utils.extend({x:(i+0*numFrames)*size.width,y:y},size) for i in range)
                    right: (Utils.extend({x:(i+1*numFrames)*size.width,y:y},size) for i in range)
                    up:    (Utils.extend({x:(i+2*numFrames)*size.width,y:y},size) for i in range)
                    left:  (Utils.extend({x:(i+3*numFrames)*size.width,y:y},size) for i in range)
                }

            animations[color].standing = genDirections(0, animated = false)
            animations[color].walking = genDirections(0)
            animations[color].extinguish_fire = genDirections(3*size.height)

        return animations
    animations = {}
    for race in races
    	animations[race] = personsAnimations(race)
    
    return animations
)
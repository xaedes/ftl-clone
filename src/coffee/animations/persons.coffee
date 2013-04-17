define(["utils","assets"], (Utils,Assets) ->
    animations = {}
    animations.races = ["human","crystal","engi","energy","female","mantis","rock","slug"]
    
    # FIXME mantis animations differs from the others :/
    


    personsAnimations = (race) ->
        if race not in animations.races 
            return
        
        size = 
            width: 35
            height: 35

        
        anims = {}
        anims.colors = ["yellow","highlight","red","green"]
        
        for color in anims.colors
            anims[color] = {}
            
            # "img/people/"+filename+".png"
            filename = race+"_"+(if color != "red" then "player" else "enemy")+"_"+color
            
            genDirections = (y,animated = true, numFrames = 4) ->
                range = if animated then [0..numFrames-1] else [0]
                return {
                    down:  (Utils.extend({x:(i+0*numFrames)*size.width,y:y},size) for i in range)
                    right: (Utils.extend({x:(i+1*numFrames)*size.width,y:y},size) for i in range)
                    up:    (Utils.extend({x:(i+2*numFrames)*size.width,y:y},size) for i in range)
                    left:  (Utils.extend({x:(i+3*numFrames)*size.width,y:y},size) for i in range)
                }

            

            anims[color].image = Assets.image('img/people/'+filename+'.png','persons')
            anims[color].standing = genDirections(0, false)
            anims[color].walking = genDirections(0)
            anims[color].extinguish_fire = genDirections(3*size.height)

        return anims
    
    for race in animations.races
    	animations[race] = personsAnimations(race)

    
    return animations
)
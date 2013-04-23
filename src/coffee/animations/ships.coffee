define(["assets"], (Assets) ->

    
    ship_names = ["kestral","kestral_2","boss_1"]

    ships_without_floor = ["boss_1"]

    ships = {}
    for ship_name in ship_names
        ships[ship_name] = {}

        if ship_name not in ships_without_floor
            ships[ship_name].floor = 
                image: Assets.image("img/ship/"+ship_name+"_floor.png", "ships."+ship_name)
        
        ships[ship_name].base = 
            image: Assets.image("img/ship/"+ship_name+"_base.png", "ships."+ship_name)    


    
    
    return ships
)
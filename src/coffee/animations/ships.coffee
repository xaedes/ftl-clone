define(["assets"], (Assets) ->

    
    

    ships = {}
    ships.kestral = {}
    ships.kestral.floor = 
        image: Assets.image("img/ship/kestral_floor.png", "ships")
    
    ships.kestral.base = 
        image: Assets.image("img/ship/kestral_base.png", "ships")
    
    
    return ships
)
define(["assets"], (Assets) ->

    
    

    ships = {}
    ships.kestral = {}
    ships.kestral.floor = 
        image: Assets.image("img/ship/kestral_floor.png", "ships.kestral")
    
    ships.kestral.base = 
        image: Assets.image("img/ship/kestral_base.png", "ships.kestral")    

    ships.kestral_2 = {}
    ships.kestral_2.floor = 
        image: Assets.image("img/ship/kestral_2_floor.png", "ships.kestral_2")
    
    ships.kestral_2.base = 
        image: Assets.image("img/ship/kestral_2_base.png", "ships.kestral_2")
    
    
    return ships
)
define(["init", "person", "ship"], (init, Person, Ship) ->
    canvas = init.canvas

    
    sampleHuman = canvas.display.person(
        race: 'human'
        tile_x: 0
        tile_y: 0
    )

    sampleShip= canvas.display.ship(
        model: 'kestral'
        x: 100
        y: 100
    )
    
    canvas.addChild(sampleShip);
    sampleShip.addChild(sampleHuman);
    
    canvas.setLoop(() -> 
        sampleHuman.update
    )
    canvas.timeline.start()
)
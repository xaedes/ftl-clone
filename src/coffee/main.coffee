define(["init", "person", "ship"], (init, Person, Ship) ->
    canvas = init.canvas

    
    samplePerson1 = canvas.display.person(
        race: 'human'
        tile_x: 1
        tile_y: 1
    )
    samplePerson2 = canvas.display.person(
        race: 'rock'
        tile_x: 2
        tile_y: 2
    )

    sampleShip = canvas.display.ship(
        model: 'kestral'
        x: 0
        y: 0
    )
    
    canvas.addChild(sampleShip);
    sampleShip.addPerson(samplePerson1);
    sampleShip.addPerson(samplePerson2);
    
    canvas.setLoop(() -> 
        #sampleHuman.update
    )
    canvas.timeline.start()
)
define(["init", "person", "ship", "person_ki"], (init, Person, Ship, KI) ->
    canvas = init.canvas

    
    samplePerson1 = canvas.display.person(
        race: 'human'
        tile_x: 1
        tile_y: 1
    )
    samplePerson2 = canvas.display.person(
        race: 'crystal'
        tile_x: 2
        tile_y: 2
    )
    samplePerson3 = canvas.display.person(
        race: 'rock'
        tile_x: 7
        tile_y: 2
        selectable: false
    )

    sampleShip = canvas.display.ship(
        model: 'kestral'
        x: 0
        y: 0
    )
    
    canvas.addChild(sampleShip);
    sampleShip.addPerson(samplePerson1);
    sampleShip.addPerson(samplePerson2);
    sampleShip.addPerson(samplePerson3);
    
    samplePerson3.mission = KI.RandomWalker.create(samplePerson3)
    
    canvas.setLoop(() -> 
        #sampleHuman.update
    )
    canvas.timeline.start()
)
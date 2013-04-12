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
    for num in [1..3]
        person = canvas.display.person(
            race: ['rock','human','female','engi'][Math.floor(Math.random()*4)]
            tile_x: Math.round(Math.random()*5 + 5)
            tile_y: Math.round(Math.random()*5 + 3)
            selectable: false
        )
        sampleShip.addPerson(person);
        person.mission = KI.RandomWalker.create(person)
    
    samplePerson3.mission = KI.RandomWalker.create(samplePerson3)
    
    canvas.setLoop(() -> 
        #sampleHuman.update
    )
    canvas.timeline.start()
)
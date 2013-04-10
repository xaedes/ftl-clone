define(["init", "person", "ship"], (init, Person, Ship) ->
    canvas = init.canvas

    
    sampleHuman = canvas.display.person({
        race: 'human',
        x: 79
    })

    sampleShip= canvas.display.ship({
        model: 'kestral',
        x: 79
    })
    
    canvas.addChild(sampleHuman);
    canvas.addChild(sampleShip);
)
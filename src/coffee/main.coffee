define(["init", "person", "ship"], (init, Person, Ship) ->
    canvas = init.canvas

    
    sampleHuman = canvas.display.person({
        race: 'human',
        x: 200,
        y: 80,
    })

    sampleShip= canvas.display.ship({
        model: 'kestral',
        x: 79
    })
    
    canvas.addChild(sampleShip);
    canvas.addChild(sampleHuman);
    
    canvas.setLoop(() -> 
        sampleHuman.x++
        sampleHuman.x = Math.min(500,sampleHuman.x)
    )
    canvas.timeline.start()
)
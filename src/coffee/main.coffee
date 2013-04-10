define(["init", "person"], (init, Person) ->
    canvas = init.canvas

    
    sampleHuman = canvas.display.person({
    	race: 'human',
    	x: 79
    })
    
    canvas.addChild(sampleHuman);
)
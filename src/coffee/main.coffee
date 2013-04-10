define(["init", "person"], (init, Person) ->
    canvas = init.canvas

    
    sampleHuman = canvas.display.person({
    	type: 'human',
    	x: 79
    })
    
    canvas.addChild(sampleHuman);
)
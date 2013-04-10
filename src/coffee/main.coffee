define(["person"], (Person) ->
    #canvas = init.canvas
    
    # canvas.addChild(image);
    
    #human23 = new Human

    canvas = oCanvas.create({
        canvas: "#canvas",
        background: "#000"
    })
    
    myObj = canvas.display.person({
        x: 79
    })
    
    
    canvas.addChild(myObj);
)
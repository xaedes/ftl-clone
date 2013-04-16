define(["init"], \
        (init) ->
            
        
    class Person extends Kinetic.Container
        selectable: true
        constructor: (config) ->
            @attrs = {}
            Kinetic.Container.call(@, config) #Call super constructor

            if @attrs.race not in ["human","crystal","engi","energy","female","mantis","rock","slug"]
                console.log "Error. Unknown person type!"
                return


            @image = new Image()
            @image.onload = () =>
                @sprite = new Kinetic.Sprite(
                    x: 100
                    y: 100
                    image: @image
                    animation: 'walking_right'
                    animations: 
                        walking_right: ({
                            x: k*35
                            y: 0
                            width: 35
                            height: 35
                        } for k in [0,1,2,3])
                    frameRate: 4
                    index: 0
                )
                @add(@sprite)
                @sprite.start()
                init.stage.draw()
            @image.src = 'img/people/human_player_yellow.png'

    # Kinetic.Global.extend(Person, Kinetic.Container);
    
    return Person
)
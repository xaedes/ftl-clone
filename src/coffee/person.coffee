define(["init","assets","animations"], \
        (init, Assets, animations) ->
            
    
    class Person extends Kinetic.Container
        selectable: true
        constructor: (config) ->
            @attrs = {}
            Kinetic.Container.call(@, config) #Call super constructor

            if @attrs.race not in ["human","crystal","engi","energy","female","mantis","rock","slug"]
                console.log "Error. Unknown person type!"
                return




            @sprite = new Kinetic.Sprite(
                x: 100
                y: 100
                image: Assets.image('img/people/human_player_green.png')
                animation: 'right'
                animations: animations.persons.human.yellow.walking
                    # walking_right: ({
                    #     x: k*35
                    #     y: 0
                    #     width: 35
                    #     height: 35
                    # } for k in [0,1,2,3])
                frameRate: 4
                index: 0
            )
            @add(@sprite)
            @sprite.attrs.image.onload = () =>
                @sprite.start()

            init.stage.draw()


    
    return Person
)
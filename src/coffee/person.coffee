define(["init","assets","animations"], \
        (init, Assets, animations) ->
            
    class Person extends Kinetic.Container
        selectable: true
        constructor: (config) ->
            #http://stackoverflow.com/questions/14530450/coffeescript-class/14536430#14536430
            @attrs = {}
            Kinetic.Container.call(@, config) #Call super constructor

            if @attrs.race not in ["human","crystal","engi","energy","female","mantis","rock","slug"]
                console.log "Error. Unknown person type!"
                return

            @attrs.layer.add(@)

            @sprite = new Kinetic.Sprite(
                x: 100
                y: 100
                image: Assets.image('img/people/human_player_green.png','persons')
                animation: 'right'
                animations: animations.persons.human.yellow.walking
                frameRate: 4
                index: 0
            )
            @add(@sprite)
            @sprite.start()

            init.stage.draw()


    
    return Person
)
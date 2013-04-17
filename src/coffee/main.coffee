requirejs.config({
    baseUrl: 'js',
    paths: {
        text: 'libs/text'
        json: 'libs/json'
    }
})

define(["init","person","assets", "person_ki"], (init, Person, Assets, PersonKI) ->
    Assets.load("persons", () -> 
        person = new Person(
            layer: init.layer
            race: "human"
            tile_x: 0
        )

        person.mission = new PersonKI.SimpleTileMovement(person, 5,1)

        fps = 60
        lastTime = Date.now()
        game_loop = ()->
            elapsedTime = Date.now() - lastTime

            person.update(elapsedTime)

            lastTime = Date.now()

            init.stage.draw()
        
        window.setInterval(game_loop,1000/fps)
    )

)
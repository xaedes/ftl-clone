requirejs.config({
    baseUrl: 'js',
    paths: {
        text: 'libs/text'
        json: 'libs/json'
    }
})

define(["init","person","ship","assets", "person_ki"], (init, Person, Ship, Assets, PersonKI) ->
    Assets.load("persons ships", () -> 
        person = new Person(
            layer: init.layers.persons
            race: "human"
            tile_x: 0
        )

        ship = new Ship(
            layer: init.layers.ships
        )

        person.mission = new PersonKI.SimpleTileMovement(person, 1,5)

        init.layers.background.add(new Kinetic.Rect(
            width: init.stage.getWidth()
            height: init.stage.getHeight()
            fill: 'black'
        ))
        init.stage.draw()

        fps = 60
        lastTime = Date.now()
        game_loop = ()->
            elapsedTime = Date.now() - lastTime

            person.update(elapsedTime)

            lastTime = Date.now()

            # init.stage.draw()
        
        window.setInterval(game_loop,1000/fps)
    )

)
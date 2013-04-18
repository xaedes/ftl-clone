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
            tile_x: 1
            tile_y: 1
        )


        ship = new Ship(
            layer: init.layers.ships
            x: 100
            y: 75
        )

        ship.addPerson(person)


        person.mission = new PersonKI.SimpleTileMovement(person, 1,3)


        for i in [1..16]
            new_person = new Person(
                layer: init.layers.persons
                race: "human"
                tile_x: Math.round(Math.clip(Math.random()*(9-6)+6,6,9))
                tile_y: Math.round(Math.clip(Math.random()*(4-1)+1,1,4))
                selectable: false
            )
            new_person.mission = new PersonKI.RandomWalker(new_person)
            ship.addPerson(new_person)


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

            ship.update(elapsedTime)


            lastTime = Date.now()

            # init.stage.draw()
        
        window.setInterval(game_loop,1000/fps)
    )

)
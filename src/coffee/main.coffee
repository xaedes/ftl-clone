requirejs.config({
    baseUrl: 'js',
    paths: {
        text: 'libs/text'
        json: 'libs/json'
    }
})

define(["init","person","assets"], (init, Person, Assets) ->
    Assets.load("persons", () -> 
        person = new Person(
            layer: init.layer
            race: "human"
        )
        init.stage.draw()
    )

)
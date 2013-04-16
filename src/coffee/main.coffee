requirejs.config({
    baseUrl: 'js',
    paths: {
        text: 'libs/text'
        json: 'libs/json'
    }
})

define(["init","person"], (init, Person) ->
    #http://stackoverflow.com/questions/14530450/coffeescript-class/14536430#14536430

    person = new Person(
        race: "human"
    )
    init.layer.add(person) 

    init.stage.draw()


)
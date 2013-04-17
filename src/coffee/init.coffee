define([], () -> 
    init = {
        stage: new Kinetic.Stage(
            container: 'container'
            width: 800
            height: 600
        )

        layers:
            ships: new Kinetic.Layer()
            persons: new Kinetic.Layer()
    }

    init.stage.add(init.layers.ships)
    init.stage.add(init.layers.persons)

    return init
)

define([], () -> 
    init = {
        stage: new Kinetic.Stage(
            container: 'container'
            width: 800
            height: 600
        )

        layer: new Kinetic.Layer()
    }

    init.stage.add(init.layer)

    return init
)

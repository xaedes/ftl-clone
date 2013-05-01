define([], () -> 
    init = {
        stage: new Kinetic.Stage(
            container: 'container'
            width: 800
            height: 600
        )

        layers:
            background: new Kinetic.Layer()
            ships: new Kinetic.Layer()
            persons: new Kinetic.Layer()
            doors: new Kinetic.Layer()
            room_selection_areas: new Kinetic.Layer()
            selection_areas: new Kinetic.Layer()
    }

    for layername, layer of init.layers
        layer.name = layername
        init.stage.add(layer)

    return init
)

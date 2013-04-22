define(["init","animations","assets","person_ki","ship_data"], (init,animations,Assets,PersonKI,ship_data) ->


    class Ship extends Kinetic.Group
        persons: []
        constructor: (config) ->
            @attrs = 
                # sprite_settings = animations.ships.kestral
                ship: "kestral"

            Kinetic.Group.call(@, config) #Call super constructor

            @data = ship_data[@attrs.ship]

            @attrs.layer.add(@)
            
            floor = new Kinetic.Image( 
                image: animations.ships[@attrs.ship].floor.image 
            )
            base = new Kinetic.Image( 
                image: animations.ships[@attrs.ship].base.image
            )
            
            @background = new Kinetic.Group({})
            @background.add(base)
            @background.add(floor)

            # @persons = new Kinetic.Group({})

            
            @add(@background)
            # @add(@persons)


            
            @on("click tap",(event) => 
                event.stopPropagation()
                if @selected_person?
                    switch event.which
                        when 1 # left click
                            @deselectPerson()
                        when 3 # right click
                            absPos = @getAbsolutePosition()
                            tile_pos = @calculateTileXY(event.layerX - absPos.x, event.layerY - absPos.y)
                            @selected_person.mission = new PersonKI.SimpleTileMovement(@selected_person,tile_pos.x,tile_pos.y)
                            # moveToTileXY(tile_pos.x,tile_pos.y)
            )
        
        calculateTileXY: (x,y,precision=false) ->
            tile_pos = 
                x: (x + @data.tile_offset.x) / @data.tile_size
                y: (y + @data.tile_offset.y) / @data.tile_size
            if not precision
                tile_pos.x = Math.floor(tile_pos.x)
                tile_pos.y = Math.floor(tile_pos.y)
            return tile_pos
        
        selectPerson: (person) ->
            if not person.attrs.selectable?
                return
            @deselectPerson()
            @selected_person = person
            @selected_person.attrs.selected = true
            @selected_person.sprite.color = "green"
            @selected_person.sprite.update()
            
        deselectPerson: () ->
            if @selected_person?
                @selected_person.attrs.selected = false
                @selected_person.sprite.color = "yellow"
                @selected_person.sprite.update()
            @selected_person = null
            
        # draw: () ->
        #     # update
        
        addPerson: (person) ->
            person.ship = this
            @add(person)
            person.selectionArea.on("click",(event) =>
                switch event.which
                    when 1 # left click
                        if person.attrs.selectable
                            @selectPerson(person)
                            event.cancelBubble = true
            )
            person.sprite.update()
            @persons.push(person)

        update: (elapsedTime) ->
            for person in @persons
                person.update(elapsedTime)
    
    return Ship
    
)
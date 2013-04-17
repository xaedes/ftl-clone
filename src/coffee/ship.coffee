define(["init","animations","assets"], (init,animations,Assets) ->


    class Ship extends Kinetic.Group
        constructor: (config) ->
            @attrs = 
                # sprite_settings = animations.ships.kestral
                tile_offset: 
                    x: 71
                    y: 116
                tile_size: 35 
            Kinetic.Group.call(@, config) #Call super constructor
            @attrs.layer.add(@)
            
            floor = new Kinetic.Image( 
                image: animations.ships.kestral.floor.image 
            )
            base = new Kinetic.Image( 
                image: animations.ships.kestral.base.image
            )
            
            @background = new Kinetic.Group({})
            @background.add(base)
            @background.add(floor)
            
            @add(@background)
            
        #     @bind("click tap",(event) => 
        #         event.stopPropagation()
        #         if @selected_person?
        #             switch event.which
        #                 when 1 # left click
        #                     @deselectPerson()
        #                 when 2 # right click
        #                     tile_pos = @calculateTileXY(event.x, event.y)
        #                     @selected_person.moveToTileXY(tile_pos.x,tile_pos.y)
        #     )
        
        # calculateTileXY: (x,y,precision=false) ->
        #     tile_pos = 
        #         x: (x - @tile_offset.x) / @tile_size
        #         y: (y - @tile_offset.y) / @tile_size
        #     if not precision
        #         tile_pos.x = Math.floor(tile_pos.x)
        #         tile_pos.y = Math.floor(tile_pos.y)
        #     return tile_pos
        
        # selectPerson: (person) ->
        #     if not person.selectable?
        #         return
        #     @deselectPerson()
        #     @selected_person = person
        #     @selected_person.sprite.color = "green"
        #     @selected_person.sprite.update()
            
        # deselectPerson: () ->
        #     if @selected_person?
        #        @selected_person.sprite.color = "yellow"
        #        @selected_person.sprite.update()
        #     @selected_person = null
            
        # draw: () ->
        #     # update
        
        # addPerson: (person) ->
        #     person.ship = this
        #     @addChild(person)
        #     person.bind("click tap",(event) =>
        #         if person.selectable
        #             @selectPerson(person)
        #         event.stopPropagation()
        #     )

        update: (elapsedTime) ->
        
    
    return Ship
    
)
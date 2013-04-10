define([""], () ->

    HumanSprites = {
        normal_down: {
            x: 0,
            y: 0,
            image: "img/people/human_player_yellow.png"
            width: 35,
            height: 35,
            generate: true,
            direction: "x",
            numFrames: 4,
            duration: 250,
            autostart: true
        }
    }
        
    HumanSprites.normal_right = oCanvas.extend({}, HumanSprites.normal_down)
    HumanSprites.normal_right.offset_x = 4*35
    HumanSprites.normal_up = oCanvas.extend({}, HumanSprites.normal_down)
    HumanSprites.normal_up.offset_x = 2*4*35
    HumanSprites.normal_left = oCanvas.extend({}, HumanSprites.normal_down)
    HumanSprites.normal_left.offset_x = 3*4*35

    return {human: HumanSprites}
)
define(["init"], (init) ->
    Container = 
        init: () ->
        
        draw: () ->
            
    
    
    containerObjectWrapper = (settings, core) ->
        settings.core = core
        settings.shapeType = "rectangular"
        oCanvas.extend({},Container, settings)
    
    oCanvas.registerDisplayObject("container", containerObjectWrapper, "init")
    
    # Activate displayObject on init.canvas
    init.canvas.display.container = oCanvas.modules.display.container.setCore(init.canvas)
    
)
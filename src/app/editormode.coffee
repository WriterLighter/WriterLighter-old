wl.editormode = class editormode
    
    @defaultMode = ->
        wl.layout.open("west");
        wl.layout.open("south");
        window.browserWindow.getFocusedWindow().setFullScreen(false);
        return
    
    @IntensiveMode = ->
        wl.layout.hide("west");
        wl.layout.hide("south");
        window.browserWindow.getFocusedWindow().setFullScreen(true);
        return
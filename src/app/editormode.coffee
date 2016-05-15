wl.editormode = class editormode
    
    #editorMode
    #0:標準モード
    #1:超集中モード
    @editorMode = 0
    
    @defaultMode = ->
        wl.layout.open("west")
        wl.layout.open("south")
        window.browserWindow.getFocusedWindow().setFullScreen(false)
        @editorMode = 0
        p = new wl.popup('toast', "モード:標準")
        p.show()
        return
    
    @IntensiveMode = ->
        wl.layout.hide("west")
        wl.layout.hide("south")
        window.browserWindow.getFocusedWindow().setFullScreen(true)
        @editorMode = 1
        p = new wl.popup('toast', "モード:超集中モード")
        p.show()
        return
    
    @toggleIntensiveMode = ->
        switch @editorMode
            when 0
                @IntensiveMode()
            when 1
                @defaultMode()
            else
                @defaultMode()
    

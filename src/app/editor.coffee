wl.editor = {}
wl.editor.mode = class editormode
    
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
 
  wl.editor.direction =
    set: (direction)->
      switch direction
        when "vertical"
          $("#input-text").addClass("vertical")
        when "horizontal"
          $("#input-text").removeClass("vertical")
        else
          wl.editor.direction.set("horizontal")
      wl.editor.direction.is = direction

    toggle: ->
      if wl.editor.direction.is is "vertical"
        wl.editor.direction.set("horizontal")
      else
        wl.editor.direction.set("vertical")

$ ->
  wl.editor.input = document.getElementById("input-text")

  $("#input-text").on "keydown", (e)->
    if wl.editor.input.innerText isnt wl.novel.previousFile and wl.editor.edited is false
      wl.editor.edited = true
    if wl.editor.input.innerText isnt wl.editor.previousInput
      clearTimeout wl.editor.saveTimeout
      wl.editor.previousInput = wl.editor.input.innerText
      wl.editor.saveTimeout = setTimeout ()->
        console.log "おーとせーぶ！"
        wl.novel.chapter.save()
      , if typeof wl.config.user.saveTimeout is "number" then wl.config.user.saveTimeout else 1000
    if wl.novel.previousFile.split("\n").length < wl.editor.input.innerText.split("\n").length and e.keyCode is 13
      document.execCommand('insertHTML', false, '　')


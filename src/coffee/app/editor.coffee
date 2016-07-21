modules.exports = editor
editor.mode = class editormode
    
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
 
  editor.direction =
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

  editor.clearWindowName = ()->
    unless isNaN(wl.novel.chapter.opened - 0)
      chaptername = wl.novel.chapter.list[wl.novel.chapter.opened - 0]
    else
      chaptername = wl.novel[wl.novel.chapter.opened].path
    document.title = "#{chaptername} - #{wl.novel.name} | WriterLighter"

$ ->
  wl.editor.input = document.getElementById("input-text")

  $("#input-text").on "input", (e)->
    if wl.editor.edited is false
      wl.editor.edited = true
      document.title = "* " + document.title
    clearTimeout wl.editor.saveTimeout
    wl.statusbar.reload()
    wl.editor.previousInput = wl.editor.input.innerText
    wl.editor.saveTimeout = setTimeout ()->
      wl.novel.chapter.save()
    , if typeof wl.config.user.saveTimeout is "number" then wl.config.user.saveTimeout else 1000

  $("#input-text").on "keyup", (e)->
    if e.keyCode is 13 and wl.editor.input.innerText.split("\n").length = wl.editor.previousInput.split("\n").length
      document.execCommand('insertHTML', false, '　')

  $(window).on "beforeunload" , ()->
    if wl.editor.edited then wl.novel.chapter.save()

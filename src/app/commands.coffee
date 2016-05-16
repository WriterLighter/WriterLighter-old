wl.commands =
  open_novel: ->
    wl.novel.open()
  open_chapter: ->
    wl.novel.chapter.open()
  command_palette: ->
    wl.command.palette()
  add_chapter: ->
    wl.novel.chapter.add()
  editmode_def: ->
    wl.editormode.defaultMode()
  editmode_int: ->
    wl.editormode.IntensiveMode()
  toggle_editmode: ->
    wl.editormode.toggleIntensiveMode()
  toggle_devtools: ->
    browserWindow.getFocusedWindow().toggleDevTools()
  reload_window: ->
    browserWindow.getFocusedWindow().reload()

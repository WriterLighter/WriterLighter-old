wl.commands =
  open_novel: ->
    wl.novel.open()
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


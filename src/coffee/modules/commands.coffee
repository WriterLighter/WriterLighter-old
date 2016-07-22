module.exports =
  open_novel: ->
    wl.novel.open()
  open_chapter: ->
    wl.novel.chapter.open()
  command_palette: ->
    wl.command.palette()
  add_chapter: ->
    wl.novel.chapter.add()
  editmode_def: ->
    wl.editor.mode.defaultMode()
  editmode_int: ->
    wl.editor.mode.IntensiveMode()
  toggle_editmode: ->
    wl.editor.mode.toggleIntensiveMode()
  toggle_devtools: ->
    browserWindow.getFocusedWindow().toggleDevTools()
  reload_window: ->
    browserWindow.getFocusedWindow().reload()
  toggle_direction: ->
    wl.editor.direction.toggle()
  new_novel: ->
    wl.novel.new()
  new_chapter: ->
    wl.novel.chapter.new()
  save: ->
    wl.novel.chapter.save()
  search: ->
    wl.search.search()
  next_chapter: ->
    wl.novel.chapter.open("next")
  back_chapter: ->
    wl.novel.chapter.open("back")
  inspect_element: ->
    remote.getCurrentWindow().inspectElement(wl.menu.contextmenuEvent.x,wl.menu.contextmenuEvent.y)

electron      = require "electron"
remote        = electron.remote
BrowserWindow = remote.BrowserWindow

module.exports =
  open_novel: ->
    wl.novel.openNovel()
  open_chapter: ->
    wl.novel.openChapter()
  command_palette: ->
    wl.command.palette()
  add_chapter: ->
    wl.novel.addChapter()
  editmode_def: ->
    wl.editor.setMode("default")
  editmode_int: ->
    wl.editor.setMode("Intensive")
  toggle_editmode: ->
    wl.editor.toggleMode()
  toggle_devtools: ->
    BrowserWindow.getFocusedWindow().toggleDevTools()
  reload_window: ->
    BrowserWindow.getFocusedWindow().reload()
  toggle_direction: ->
    wl.editor.toggleDirection()
  new_novel: ->
    wl.novel.newNovel()
  new_chapter: ->
    wl.novel.newChapter()
  save: ->
    wl.novel.save()
  search: ->
    wl.search.search()
  next_chapter: ->
    wl.novel.openChapter("next")
  back_chapter: ->
    wl.novel.openChapter("back")
  inspect_element: ->
    if __menu? and __menu.contextMenuEvent?
      __menu.browserWindow.inspectElement __menu.contextMenuEvent.x, __menu.contextMenuEvent.y
    else
      (new wl.Popup("toast", "コンテキストメニューから実行してください。")).show()

electron      = require "electron"
remote        = electron.remote
app           = remote.app

Popup = require "./popup"

module.exports =
  quit: ->
    app.quit()
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
    wl.editor.setMode("intensive")
  toggle_editmode: ->
    wl.editor.toggleMode()
  toggle_devtools: ->
    remote.getCurrentWindow().toggleDevTools()
  reload_window: ->
    remote.getCurrentWindow().reload()
  toggle_direction: ->
    wl.editor.toggleDirection()
  new_novel: ->
    wl.novel.newNovel()
  new_chapter: ->
    wl.novel.newChapter()
  rename_chapter: ->
    do wl.novel.renameChapter
  delete_chapter: ->
    do wl.deleteChapter
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
      new Popup messeage: "コンテキストメニューから実行してください。"

app    = require("electron").app
fs     = reqiure "fs"
novel  = require "./novel"
editor = require "./editor"

module.exports = class lastEdit
  lastEditPath= path.join(app.getPath("userData"), "lastedit.json")
  @save: ->
    savedata =
      opened: do novel.getOpened
      status:
        mode: do editor.getMode
        direction: do editor.getDirection
    fs.writeFileSync lastEditPath, JSON.stringify(savedata)

  @restore: ->
    fs.readFile lastEditPath, (err, text) ->
      unless err?
        data = JSON.parse text
        novel.openNovel data.opened.novel.name
        novel.openChapter data.opened.chapter.name
      else novel.openNovel "はじめよう"

$ ->
  do lastEdit.restore
$(window).on "beforeunload", ->
  wl.lastedit.save()


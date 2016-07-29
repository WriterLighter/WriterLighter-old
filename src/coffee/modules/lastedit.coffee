app    = require("electron").remote.app
fs     = require "fs"
path   = require 'path'

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
        novel.openChapter data.opened.chapter.index - 1
        editor.setMode data.status.mode
        editor.setDirection data.status.direction
      else novel.openNovel "はじめよう"

novel  = require "./novel"
editor = require "./editor"

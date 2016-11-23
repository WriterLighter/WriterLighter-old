app    = require("electron").remote.app
YAML   = require "js-yaml"
fs     = require "fs"
path   = require 'path'

module.exports = class lastEdit
  lastEditPath= path.join(app.getPath("userData"), "lastedit.yml")
  @save: ->
    savedata =
      opened: do novel.getOpened
      status:
        direction: do editor.getDirection
    fs.writeFileSync lastEditPath, YAML.dump(savedata)

  @restore: ->
    fs.readFile lastEditPath, (err, text) ->
      unless err?
        data = YAML.load text
        {name, number} = data.opened

        if name?
          novel.openNovel name
        else
          novel.openNovel "はじめよう"

        number? and novel.openChapter number

        editor.setDirection data.status.direction
      else novel.openNovel "はじめよう"

novel  = require "./novel"
editor = require "./editor"

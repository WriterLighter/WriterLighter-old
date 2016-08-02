Popup = require "./popup"

module.exports = class command
  commands = require "./commands"
  @execute: (command)->
    c = command.split(":")
    switch c.length
      when 1
        commands[c[0]]?()
      when 2
        extensions.commands[c[0]][c[1]]?()
      else
        "Bad Command!"

  @palette: ->
    palette = new Popup("prompt")
    palette.messeage = "コマンドを入力…"
    palette.complete = do command.getList
    palette.callback = command.execute
    palette.show()

  @getList = ->
    Object.keys commands

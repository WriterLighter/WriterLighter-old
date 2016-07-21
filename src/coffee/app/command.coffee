modules.exports =
  execute: (command)->
    c = command.split(":")
    switch c.length
      when 1
        wl.commands[c[0]]()
      when 2
        wl.extensions.commands[c[0]][c[1]]()
      else
        "Bad Command!"

  palette: ->
    palette = new wl.popup("prompt")
    palette.messeage = "コマンドを入力…"
    palette.complete = Object.keys(wl.commands)
    palette.callback = (command)->
      wl.command.execute command
    palette.show()

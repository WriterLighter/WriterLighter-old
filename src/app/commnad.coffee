wl.command =
  execute: (command)->
    c = command.split(":")
    switch c.length
      when 1
        wl.commands[c[0]]()
      when 2
        wl.extensions.commands[c[0]][c[1]]()
      else
        "Bad Command!"

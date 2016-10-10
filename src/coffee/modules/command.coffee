Popup = require "./popup"

module.exports = class command
  commands =
    default: require "./commands"

  parse = (command) ->
    args = command.split " "
    c = args.pop().split ":"
    args: args
    extension: if c[1]? then c[0] else null
    command: if c[1]? then c[1] else c[0]

  @execute: (command)->
    c = parse command
    if c.extension?
      extensions.commands[c.extension][c.command].apply @, c.args
    else
      commands[c.command].apply @, c.args

  @palette: ->
    palette = new Popup("prompt")
    palette.messeage = "コマンドを入力…"
    palette.complete = do command.getList
    palette.callback = command.execute
    palette.show()

  @getList = ->
    Object.keys commands

  @marge(margeCommands, extname) ->
  if extname isnt "default"
    Object.assign commands[extname], margeCommands

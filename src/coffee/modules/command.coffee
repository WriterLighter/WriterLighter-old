Popup = require "./popup"

module.exports = class command
  commands =
    default: require "./commands"

  parse = (command) ->
    args = command.split " "
    c = args.shift().split ":"
    args: args
    extension: if c[1]? then c[0] else "default"
    command: c.pop()

  @execute: (command)->
    c = parse command
    commands[c.extension][c.command].apply @, c.args

  @palette: ->
    palette = new Popup
      type:"prompt"
      messeage: "コマンドを入力…"
      complete: do command.getList

    palette.on "hide", command.execute

  @getList = ->
    Object.keys commands

  @marge = (margeCommands, extname) ->
    if extname isnt "default"
      Object.assign commands[extname], margeCommands

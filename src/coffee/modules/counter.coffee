editor    = require "./editor"
statusBar = require "./statusBar"

module.exports = class counter
  @get = (type)->
    val = do editor.getText
    res = 0

    switch type
      when "letter"
        res = val.length

      when "line"
        res = val.split("\n").length

      when "byte"
        res = encodeURIComponent val
          .replace /%../g, "x"
          .length

    res

  @count = ->
    val = do editor.getText
    res = 0

    statusBar.register "letter", val.length + "文字"

    statusBar.register "line", val.split("\n").length + "行"

    byte =
      encodeURIComponent val
        .replace /%../g, "x"
        .length

    statusBar.register "byte",
      (unless byte < 1024 then Math.floor(byte / 1024 * 100) + "キロ" /100 else byte)
      + "バイト"

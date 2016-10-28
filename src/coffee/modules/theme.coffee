fs     = require "fs"
sass   = require "sass.js"
path   = require "path"
accord = require "accord"
less   = accord.load "less"
$theme = $ "#theme"

module.exports = class theme
  @set= (theme = config.get("theme") or "wl-light") ->
    config.set "theme", theme
    themeFile = path.join extension.get(theme, "path"), extension.get(theme, "main")
    ext = path.parse(themeFile).ext
    switch ext
      when "css"
        fs.readFile themeFile, (e, r)->
          if e? then throw e
          $theme.html r

      when "sass"
        sass.compileFile themeFile, (r)->
          $theme.html r

      when "scss"
        sass.compileFile themeFile, (r)->
          $theme.html r

      when "less"
        less.renderFile themeFile, (r)->
          $theme.html r

  @getList = ->
    extension.getList "theme"

config    = require "./config"
extension = require "./extension"

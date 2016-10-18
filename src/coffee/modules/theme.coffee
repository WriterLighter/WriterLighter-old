$theme = $ "#theme"

module.exports = class theme
  @set= (theme = config.get("theme") or "wl-light") ->
    config.set "theme", theme
    $theme.html extension.get theme

  @getList = ->
    extension.getList "theme"

config    = require "./config"
extension = require "./extension"

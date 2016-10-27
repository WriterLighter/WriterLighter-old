path   = require 'path'
app    = require('electron').remote.app
dialog = require('electron').dialog
fs     = require 'fs'
YAML   = require "js-yaml"

module.exports = class config
  configs = []
  configIndex = {}
  configFile = path.join app.getPath("userData"), "config.yml"

  @save = ->
    try
      fs.writeFileSync configFile, YAML.dump(configs)
      return configs
    catch
      return {}

  @load = ->
    configs = YAML.load fs.readFileSync(configFile, 'utf8')
    for cfg, index in configs
      configIndex[cfg.name] = index

  @get = (name, key = "value")->
      configs[configIndex[name]]?[key]
  
  @set= (name, value, key = "value") ->
    unless configIndex[name]?
      configIndex[name] = configs.push {}

    if Object::toString.call(value) is "[object Object]"
      configs[configIndex[name]] = value
    else
      configs[configIndex[name]][key] = value

    do config.save

ModalWindow = require "./modalwindow"
Popup       = require './popup'

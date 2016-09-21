path   = require 'path'
app    = require('electron').remote.app
dialog = require('electron').dialog
fs     = require 'fs'

module.exports = class config
  configs = []
  configIndex = {}
  configFile = path.join app.getPath("userData"), "config.json"

  @save = ->
    try
      fs.writeFileSync configFile, JSON.stringify(configs)
      return configs
    catch
      return {}

  @load = ->
    configs = JSON.parse fs.readFileSync(configFile, 'utf8')
    for config, index in configs
      configIndex[config.name] = index

  @get = (name, key = "value")->
    configs[configIndex[name]][key]
  
  @set= (name, value, key = "value") ->
    if configIndex[name]?
      configIndex[name] = configs.push {}
    if Object::toString.call(value) is "[object Object]"
      configs[configIndex[name]] = value
    else
      configs[configIndex[name]][key] = value

ModalWindow = require "./modalwindow"
Popup       = require './popup'

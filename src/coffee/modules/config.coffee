mkdirp = require 'mkdirp'
path   = require 'path'
app    = require('electron').remote.app
dialog = require('electron').dialog
fs     = require 'fs'

module.exports = class config
  configs = {}
  configFile = path.join app.getPath("userData"), "config.json"
  merge = (object, override = false) =>
    if override then $.extend(configs, object) else $.extend(true, configs, object)

  @save = ->
    try
      fs.writeFileSync configFile, JSON.stringify(configs)
      return configs
    catch
      return {}

  @load = ->
    res = true
    try
      configs = JSON.parse fs.readFileSync(configFile, 'utf8')
      unless Object.keys(configs).length
        throw 'No Configs.'
    catch e
      do config.init
      res = false

    return res

  @get = (name)->
    names = name.split '.'
    res = null unless configs[names[0]]?
    res =  config.get(names.slice(1).join('.'), configs[names[0]]) if names.length > 1
    res = configs[names[0]]
    res
    
  @set= (name, val, override = false) =>
    names = name.split '.'
    obj   = {}
    elm   = obj

    for key, i in names
      elm[key] = if i == names.length - 1 then val else {}
      elm = elm[key]

    merge obj, override
    val

ModalWindow = require "./modalwindow"
Popup       = require './popup'

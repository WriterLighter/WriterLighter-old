YAML     = require "js-yaml"
command  = require "./command"
electron = require "electron"
Menu     = electron.remote.Menu
fs       = require 'fs'

module.exports = class menu
  _TMP_CONTEXT_MENU_EVENT = null
  appmenu  = {}
  context  = {}
  template = {}
  appmenu  = {}
  
  @buildTemplate: (data, type="app")->
    data.forEach (item, index)->
      if item.submenu?
        data[index].submenu = menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = ->
          contextMenuEvent = _TMP_CONTEXT_MENU_EVENT
          command.execute(data[index].command)
          contextmenuEvent = undefined
    data

  @load: ->
    template = YAML.safeLoad fs.readFileSync("menu.yml")
    appmenu = Menu.buildFromTemplate menu.buildTemplate(template.appmenu)
    Menu.setApplicationMenu appmenu

  @showContextMenu:(event) ->
    addtionalMenu = event.target.dataset.context
    cmenu = template.context.main.concat()
    if addtionalMenu?
      addtionalMenu.split(" ").forEach (item, index)->
        cmenu.push
          type: "separator"
        cmenu = cmenu.concat menu.template.context[item]
    _TMP_CONTEXT_MENU_EVENT = event
    Menu.buildFromTemplate(menu.buildTemplate(cmenu)).popup()

window.addEventListener "contextmenu", menu.showContextMenu

YAML     = require "js-yaml"
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
    for item, index in data
      if item.submenu?
        data[index].submenu = menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = (menuItem, browserWindow, event)->
          window.__menu =
            menuItem: menuItem
            browserWindow: browserWindow
            event: event
            contextMenuEvent: _TMP_CONTEXT_MENU_EVENT or undefined

          command.execute(data[index].command)

          window.__menu = undefined
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
        cmenu = cmenu.concat template.context[item]
    _TMP_CONTEXT_MENU_EVENT = event
    Menu.buildFromTemplate(menu.buildTemplate(cmenu)).popup()

window.addEventListener "contextmenu", menu.showContextMenu

command  = require "./command"

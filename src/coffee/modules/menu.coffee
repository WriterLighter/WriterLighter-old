YAML     = require "js-yaml"
command  = require "./command"
electron = require "electron"
Menu     = electron.Menu

module.exports = class menu
  _TMP_CONTEXT_MENU_EVENT = null
  appmenu  = {}
  context  = {}
  template = {}
  appmenu  = {}

  _TMP_CONTEXT_MENU_EVENT = null
  
  @buildTemplate: (data, type="app")->
    data.forEach (item, index)->
      if item.submenu?
        data[index].submenu = wl.menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = ->
          contextMenuEvent = _TMP_CONTEXT_MENU_EVENT
          command.execute(data[index].command)
          contextmenuEvent = undefined
    data

  @load: ->
    template = YAML.safeLoad fs.readFileSync("menu.yml")
    appmenu = Menu.buildFromTemplate buildTemplate(template.appmenu)
    Menu.setApplicationMenu appmenu

  @showContextMenu:(event) ->
    addtionalMenu = event.target.dataset.context
    cmenu = template.context.main.concat()
    if addtionalMenu?
      addtionalMenu.split(" ").forEach (item, index)->
        cmenu.push
          type: "separator"
        cmenu = cmenu.concat wl.menu.template.context[item]
    _TMP_CONTEXT_MENU_EVENT = event
    Menu.buildFromTemplate(wl.menu.buildTemplate(cmenu)).popup()

window.addEventListener "contextmenu", menu.showContextMenu

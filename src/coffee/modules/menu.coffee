$ ->
  wl.menu.template = YAML.safeLoad fs.readFileSync("menu.yml")
  wl.menu.appmenu = Menu.buildFromTemplate wl.menu.buildTemplate(wl.menu.template.appmenu)
  Menu.setApplicationMenu wl.menu.appmenu

module.exports =
  appmenu: {}
  context: {}
  buildTemplate: (data, type="app")->
    data.forEach (item, index)->
      if item.submenu?
        data[index].submenu = wl.menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = ->
          wl.menu.contextmenuEvent = window._tmpcontextmenu
          wl.command.execute(data[index].command)
          wl.menu.contextmenuEvent = undefined
    data

window.addEventListener "contextmenu", (e)->
  addtionalMenu = e.target.dataset.context
  cmenu = wl.menu.template.context.main.concat()
  if addtionalMenu?
    addtionalMenu.split(" ").forEach (item, index)->
      cmenu.push
        type: "separator"
      cmenu = cmenu.concat wl.menu.template.context[item]
  window._tmpcontextmenu = e
  Menu.buildFromTemplate(wl.menu.buildTemplate(cmenu)).popup()

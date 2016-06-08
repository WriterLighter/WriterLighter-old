$ ->
  wl.menu.template = YAML.safeLoad fs.readFileSync("src/menu.yml")
  wl.menu.appmenu = Menu.buildFromTemplate wl.menu.buildTemplate(wl.menu.template.appmenu)
  Menu.setApplicationMenu wl.menu.appmenu

wl.menu =
  appmenu: {}
  context: {}
  buildTemplate: (data)->
    data.forEach (item, index)->
      if item.submenu?
        data[index].submenu = wl.menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = ->
          wl.command.execute(data[index].command)
    data

$(window).on "contextmenu", (e)->
  addtionalMenu = e.target.dataset.context
  cmenu = wl.menu.template.context.main.concat()
  if addtionalMenu?
    addtionalMenu.split(" ").forEach (item, index)->
      cmenu.push
        type: "separator"
      cmenu = cmenu.concat wl.menu.template.context[item]
  Menu.buildFromTemplate(wl.menu.buildTemplate(cmenu)).popup()

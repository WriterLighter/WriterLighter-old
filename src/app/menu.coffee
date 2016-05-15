$ ->
  template = YAML.safeLoad fs.readFileSync("src/menu.yml")
  wl.menu.appmenu = Menu.buildFromTemplate wl.menu.buildTemplate(template.appmenu)
  Menu.setApplicationMenu wl.menu.appmenu


wl.menu =
  buildTemplate: (data)->
    data.forEach (item, index)->
      if item.submenu?
        data[index].submenu = wl.menu.buildTemplate(item.submenu)
      else if item.command?
        data[index].click = ->
          wl.command.execute(data[index].command)
    data

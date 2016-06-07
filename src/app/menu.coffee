$ ->
  wl.menu.template = YAML.safeLoad fs.readFileSync("src/menu.yml")
  wl.menu.appmenu = Menu.buildFromTemplate wl.menu.buildTemplate(wl.menu.template.appmenu)
  Menu.setApplicationMenu wl.menu.appmenu

  for k, v of wl.menu.template.context
    console.log k
    wl.menu.context[k] = Menu.buildFromTemplate wl.menu.buildTemplate(v)


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
  wl.menu.context.main.popup()
  e.preventDefault()

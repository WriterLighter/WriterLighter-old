wl.extensions =
  list: [
    path.join ".", "extensions"
    path.join app.getPath("userData"), "extensions"
  ]
  load: ->
    tabs = ""
    wl.extensions.list.forEach (p) ->
      extpath = glob.sync path.join(p ,"*", "package.json")
      extpath.forEach (item,index)->
        extdirpath = path.dirname item
        unless path.isAbsolute(extdirpath)
          extdirpath = path.join(__dirname, "..", extdirpath)
        data = JSON.parse fs.readFileSync(item, 'utf-8')
        wl.extensions[data.name] = require path.join(extdirpath, data.main)
        wl.extensions[data.name].path = extdirpath
        if wl.extensions[data.name].view?
          tabs += "<li><input type='radio' name='ext-tabs' \
          style='background-image:url(#{path.join extdirpath, data.icon})' \
          data-name='#{data.name}' ></li>"
    $("#ext-tab").html tabs
    viewext = ->
      name = $("[name='ext-tabs']:checked").data "name"
      html = fs.readFileSync(path.join(wl.extensions[name].path, wl.extensions[name].view)).toString()
      $("#ext-content").html html
    $("[name='ext-tabs']").on "change", viewext
    $("[name='ext-tabs']").first().prop "checked", true
    viewext()

$ ->
  wl.extensions.load()

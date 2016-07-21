modules.exports =
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
          style='background-image:url(#{if data.icon? then path.join(extdirpath, data.icon) else ""})' \
          data-name='#{data.name}' ></li>"
    $("#ext-tab").html tabs
    viewext = ->
      name = $("[name='ext-tabs']:checked").data "name"
      wl.extensions.open name
    $("[name='ext-tabs']").on "change", viewext
    $("[name='ext-tabs']").first().prop "checked", true
    viewext()
  open: (name)->
    $("[name='ext-tabs'][data-name='#{name}']").prop "checked", true
    html = fs.readFileSync(path.join(wl.extensions[name].path, wl.extensions[name].view)).toString()
    $("#ext-content").html html
    wl.extensions[name].onview && wl.extensions[name].onview()

$(window).on "load", ->
 wl.extensions.load()

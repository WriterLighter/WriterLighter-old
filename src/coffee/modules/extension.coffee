module.exports = class extensions
  extensions = {}
  extensionPaths = {}
  packageJsons = {}
  extensionDirList = [
    path.join ".", "extensions"
    path.join app.getPath("userData"), "extensions"
  ]

  $tabs = $ "#ext-tab"
  $content = $ "#ext-conteni"


  viewExtension = ->
    name = $("[name='ext-tabs']:checked").data "name"
    extensions.open name

  @load: ->
    tabs = ""
    extensionDirList.forEach (p) ->
      extpath = glob.sync path.join(p ,"*", "package.json")
      extpath.forEach (item,index)->
        extdirpath = path.dirname item
        unless path.isAbsolute(extdirpath)
          extdirpath = path.join(__dirname, "..", extdirpath)
        data = JSON.parse fs.readFileSync(item, 'utf-8')
        packageJsons[data.name]   = data
        extensions[data.name]     = require path.join(extdirpath, data.main)
        extensionPaths[data.name] = extdirpath
        if extensions[data.name].view?
          tabs += "<li><input type='radio' name='ext-tabs' \
          style='background-image:url(#{if data.icon? then path.join(extdirpath, data.icon) else ""})' \
          data-name='#{data.name}' ></li>"
    $tabs.html tabs
    $("[name='ext-tabs']").on "change", viewext
    $("[name='ext-tabs']").first().prop "checked", true
    do viewext

  @open: (name)->
    $("[name='ext-tabs'][data-name='#{name}']").prop "checked", true
    html = fs.readFileSync(path.join(extensionPaths[name], extensions[name].view)).toString()
    $("#ext-content").html html
    extensions[name].onview?()

$(window).on "load", ->
 extensions.load()

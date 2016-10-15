require('coffee-script').register()
glob = require 'glob'
path = require 'path'
app  = require("electron").remote.app
fs   = require 'fs'

module.exports = class extension
  extensions = []
  extensionDirList = config.get("extensionDirectory") ? [
    path.join ".", "extensions"
    path.join app.getPath("userData"), "extensions"
  ]
  extensionIndex = {}
  extensionFile = path.join app.getPath("userData"), "extensions.yml"

  $tabList = $ "#ext-tab"
  $content = $ "#ext-content"


  viewExtension = ->
    name = $("[name='ext-tabs']:checked").data "name"
    extensions.open name


  extTabTag = (pkgInfo) ->
    "<li><input type='radio' name='ext-tabs' \
    style='background-image:url(#{if pkgInfo.icon? then path.join(pkgInfo.path, pkgInfo.icon) else ""})' \
    value='#{pkgInfo.name}' ></li>"


  @checkInstall: ->
    for extDir in extensionDirList
      for packageJSON in glob.sync path.join extDir, "*", "package.json"
        packagePath = path.dirname packageJSON
        unless path.isAbsolute packagePath
          packagePath = path.join __dirname, "..", packagePath
        packageInfo = JSON.parse fs.readFileSync(packageJSON, "utf-8")
        unless ~extensionIndex.indexOf packageInfo
          imported = switch path.parse(packageInfo.main).ext
            when "css"
              fs.readFileSync path.join(packagePath, packageInfo.main)
            when "coffee"
              require path.join(packagePath, packageInfo.main)
            when "js"
              require path.join(packagePath, packageInfo.main)

          extensionIndex[packageInfo.name] = extensions.push Object.assign({},
            packageInfo,
            path: packageInfoPath
            imported: imported
            )
          do extension.save


  @save = ->
    fs.writeFileSync extensionFile, YAML.safeDump(extensions)

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
    $ "[name='ext-tabs']"
      .on "change", viewExtension
      .first().prop "checked", true
    if $("[name='ext-tabs']").length then do viewExtension

  @open: (name)->
    $("[name='ext-tabs'][data-name='#{name}']").prop "checked", true
    html = fs.readFileSync(path.join(extensionPaths[name], extensions[name].view)).toString()
    $("#ext-content").html html
    extensions[name].onview?()

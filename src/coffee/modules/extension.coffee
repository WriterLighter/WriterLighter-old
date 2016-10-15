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
    do extension.updateExtensionTabs

  @updateExtensionTabs= ->
    html = ""
    for ext in extensions
      html += extTabTag ext
    $tabList.html html

  @save = ->
    fs.writeFileSync extensionFile, YAML.safeDump(extensions)

  @load: ->
    extensions = YAML.load fs.readFileSync(extensionFile, 'utf8')
    for extension, index in extensions
      extensionIndex[extension.name] = index
      extension.imported = require path.join(extsnsion.path, extension.main)
    do extension.updateExtensionTabs

  @open: (name)->
    $("[name='ext-tabs'][data-name='#{name}']").prop "checked", true
    html = fs.readFileSync(path.join(extensionPaths[name], extensions[name].view)).toString()
    $("#ext-content").html html
    extensions[name].onview?()

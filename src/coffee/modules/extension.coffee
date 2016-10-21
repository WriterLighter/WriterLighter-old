require('coffee-script').register()
glob = require 'glob'
path = require 'path'
app  = require("electron").remote.app
fs   = require 'fs'

module.exports = class extension
  extensions = []
  getExtensionDirList = ->
    config.get("extensionDirectory") ? [
      path.join ".", "extensions"
      path.join app.getPath("userData"), "extensions"
    ]
  extensionIndex = {}
  themeIndex     = {}
  extensionFile = path.join app.getPath("userData"), "extensions.yml"

  $tabList = $ "#ext-tab"
  $content = $ "#ext-content"

  $tabList.on "change", "input", ->
    extensions.open this.value

  extTabTag = (pkgInfo) ->
    "<li><input type='radio' name='ext-tabs' \
    style='background-image:url(#{if pkgInfo.icon? then path.join(pkgInfo.path, pkgInfo.icon) else ""})' \
    value='#{pkgInfo.name}' ></li>"


  @checkInstall: ->
    for extDir in do getExtensionDirList
      for packageJSON in glob.sync path.join extDir, "*", "package.json"
        packagePath = path.dirname packageJSON
        unless path.isAbsolute packagePath
          packagePath = path.join __dirname, "..", packagePath
        packageInfo = JSON.parse fs.readFileSync(packageJSON, "utf-8")
        unless ~extensionIndex.indexOf(packageInfo.name) and ~themeIndex.indexOf(packageInfo.name)
          ext = path.parse(packageInfo.main).ext
          if ext is "js" or ext is "coffee"
            imported = require path.join(packagePath, packageInfo.main)
            index = extensionIndex
            type = "extension"
          else
            imported =  fs.readFileSync path.join(packagePath, packageInfo.main)
            index = themeIndex
            type = "theme"

          index[packageInfo.name] = extensions.push Object.assign({},
            packageInfo,
            path: packageInfoPath
            imported: imported
            type: type
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
    do extension.checkInstall
    extensions = YAML.load fs.readFileSync(extensionFile, 'utf8')
    for extension, i in extensions
      index = switch extension.type
        when "extension"
          extensionIndex
        when "theme"
          themeIndex
      index[extension.name] = i
      extension.imported = require path.join(extsnsion.path, extension.main)
    do extension.updateExtensionTabs
    do theme.set

  @open: (name)->
    $("[name='ext-tabs'][data-name='#{name}']").prop "checked", true
    html = do fs.readFileSync(path.join(extensions[name].path, extensions[name].view)).toString
    $("#ext-content").html html
    extensions[name].onview?()

  @get: (name, prop="imported") ->
    extensions[extensionIndex[name] or themeIndex[name]][prop]

  @getList: (type="extensions") ->
    switch type
      when "extensions"
        Object.keys extensionIndex
      when "theme"
        Object.keys themeIndex

config = require "./config"
theme  = require "./theme"

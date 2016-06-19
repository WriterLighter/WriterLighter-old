wl.extensions =
  list: [
    path.join ".", "extensions"
    path.join app.getPath("userData"), "extensions"
  ]
  load: ->
    wl.extensions.list.forEach (p) ->
      glob path.join(p ,"*", "package.json"), (o_O,extpath)->
        extpath.forEach (item,index)->
          extdirpath = path.dirname item
          unless path.isAbsolute(extdirpath)
            extdirpath = path.join(__dirname, "..", extdirpath)
          data = JSON.parse fs.readFileSync(item, 'utf-8')
          wl.extensions[data.name] = require path.join(extdirpath, data.main)
          wl.extensions[data.name].path = extdirpath


$ ->
  wl.extensions.load()

module.exports =
  path : path.join(app.getPath("userData"), "lastedit.json")
  save: ->
    savedata = {}
    savedata.novel = wl.novel.name
    savedata.chapter = wl.novel.chapter.opened
    fs.writeFileSync wl.lastedit.path, JSON.stringify(savedata)

$ ->
  fs.readFile wl.lastedit.path, (err, data)->
    unless err?
      lastedit = JSON.parse data
      wl.novel.open lastedit.novel
      wl.novel.chapter.open lastedit.chapter
    else
      wl.novel.open "はじめよう"

$(window).on "beforeunload", ->
  wl.lastedit.save()


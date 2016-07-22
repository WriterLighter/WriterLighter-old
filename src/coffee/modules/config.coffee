path = require 'path'
module.exports = class config
  @path = path.join app.getPath("userData"), "config.json"
  @save = ->
    fs.writeFile wl.config.path, JSON.stringify(wl.config.user)
  @init= ->
# TODO: 「はじめる(名称仮)」作る
    ###
    # 初回起動時に開く
    fs.copySync path.join(__dirname, "はじめまして"), wl.bookshalf.path
    wl.novel.open("はじめまして")
    ###
    bspath = path.join app.getPath("documents"), "Novels"
    modal = new wl.modalwindow("ようこそ！")
    modal.content = fs.readFileSync("welcome.html").toString()
    modal.forcing = true
    modal.show()
    $("form#welcome [name='bookshalf']").val bspath
    $("form#welcome [name='browse']").on "click", ->
      selectedpath = dialog.showOpenDialog
        properties: ['oepnDirectory','createDirectory']
        defaultPath: $("form#welcome [name='bookshalf']").val()
      if selectedpath?
        $("form#welcome [name=bookshalf]").val selectedpath
    $("form#welcome").on "submit", ->
      wl.config.user.name = $("form#welcome [name='name']").val()
      wl.config.user.bookshalf = $("form#welcome [name='bookshalf']").val()
      $("#modal-window").removeClass "show"
      return false

$ ->
  fs.readFile wl.config.path, (err,data)->
    if data? and Object.keys(data).length isnt 0
      wl.config.user = JSON.parse data
      glob path.join(wl.config.user.bookshalf,"*","index.json"), (e,d)->
        list = []
        d.forEach (item,index)->
          list.push path.basename(path.dirname(item))
        wl.novel.list = list
    else
      wl.config.init()

$(window).on "beforeunload", ->
  wl.config.save()


wl.config = class config
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
    switch process.platform
      when "darwin" and "win32"
        bspath = path.join app.getPath("home"),"/Documents/Novels"
      else
        bspath = path.join app.getPath("documents"),"/Novels"
    p = new wl.popup("prompt")
    p.messeage = [
      "あなたのペンネームを入力してください。"
      "小説の保存するフォルダを入力してください。"
    ]
    p.forcing = true
    p.callback = (res)->
        wl.config.user =
          name: res[0]
          bookshalf: if res[1] isnt "" then res[1] else bspath
    p.show()

$ ->
  fs.readFile wl.config.path, (err,data)->
    if data? and Object.keys(data).length isnt 0
      wl.config.user = JSON.parse data
    else
      wl.config.init()

$(window).on "beforeunload", ->
  wl.config.save()


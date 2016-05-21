wl.novel =
  chapter:
    open: (number) ->
      _open = (path) ->
        fs.readFile path, 'utf8', (e, t)->
          unless e?
            wl.novel.chapter.path = path
            $("#input-text").text(t)
            wl.novel.chapter.opened = number
            wl.lastedit.save()
          else
            err = new wl.popup()
            err.messeage = e
            err.show()

      unless isNaN(number - 0)
          _open(path.join(wl.novel.path,"/本文/",wl.novel.chapter.list[number] + ".txt"))
        else if number? and name isnt ""
          _open(path.join(wl.novel.path,wl.novel[number].path))
        else
          getChapter = new wl.popup("prompt")
          getChapter.messeage = "章名またはタイプ(afterwordなど)を入力…"
          getChapter.callback = (chapter)->
            wl.novel.chapter.open(chapter)
          getChapter.show()

  description:{}
  afterword:{}
  open: (name)->

    _open =  (novelname)->
      wl.novel.name = novelname
      wl.novel.path = novelpath =path.join(wl.bookshalf.path,novelname)
      index = JSON.parse(fs.readFileSync(path.join(novelpath,"index.json"),"utf-8"))
      wl.novel.chapter.list = index.chapter
      wl.novel.description.path = index.description
      wl.novel.afterword.path = index.afterword
      wl.novel.author = index.author
      list = ""
      wl.novel.chapter.list.forEach (item,index)->
        list +=  "<li onclick='wl.novel.chapter.open(#{index})'>#{item}</li>"
      $("#chapter-list").html(list)
      if index.chapter.length is 0 then wl.novel.chapter.new() else wl.novel.chapter.open(0)

    if name? and name isnt ""
      _open name
    else
      getNovelName = new wl.popup("prompt")
      getNovelName.messeage = "小説名を入力…"
      getNovelName.callback = (name)->
        wl.novel.open name
      getNovelName.show()

  new: (name)->
    if name? and name isnt ""
      index =
        name: name
        author: wl.config.user.name
        description: "説明.txt"
        afterword: "あとがき.txt"
        chapter: []

      fs.mkdirs path.join(wl.config.bookshalf, name), (e)->
        unless e?
          fs.write path.join(wl.config.bookshalf, name, "index.json"), JSON.stringify(index), (e)->
            unless e?
              wl.novel.open name
    else
      p = new wl.popup("prompt", "小説名を入力…")
      p.callback = (name)->
        wl.novel.new name
      p.show()

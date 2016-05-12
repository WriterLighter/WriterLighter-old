wl.novel =
  chapter:
    open: (number) ->
      _open = (path) ->
        fs.readFile path, 'utf8', (e, t)->
          unless e?
            wl.novel.chapter.path = path
            $("#input-text").text(t)
            wl.novel.chapter.opened = number
          else
            err = new wl.popup()
            err.messeage = e
            err.show()

      unless isNaN(number - 0)
          _open(path.join(wl.novel.path,"/本文/",wl.novel.chapter.list[number-1] + ".txt"))
        else if number?
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
      wl.novel.chapter.list.forEach (item,index)->
        $("#chapter-list").append "<li oncick='wl.novel.chapter.open(#{index})'>#{item}</li>"

    unless name?
      getNovelName = new wl.popup("prompt")
      getNovelName.messeage = "小説名を入力…"
      getNovelName.callback = (name)->
        _open(name)
      getNovelName.show()
    else _open(name)



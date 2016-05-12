wl.novel =
  chapter:
    open: (number) ->
      fs.readFile(path.join(wl.novel.path,"/本文/",wl.novel.chapter.list[number] + ".txt"), 'utf8', (e, t)->
        unless e?
          wl.novel.chapter.path = path.join(wl.novel.path,"/本文/",wl.novel.chapter.list[number] + ".txt")
          $("#input-text").text(t)
          wl.novel.chapter.opened = number
        else
          err = new wl.popup()
          err.messeage = e
          err.show()
      )
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
      getNovelName.messeage = "Type Novel's Name..."
      getNovelName.callback = (name)->
        _open(name)
      getNovelName.show()
    else _open(name)



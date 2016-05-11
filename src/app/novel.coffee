wl.novel =
  chapter: {}
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
        $("#chapter-list").append "<li oncick='wl.novel.chapter.open(#{item})'>#{item}</li>"

    unless name?
      getNovelName = new wl.popup("prompt")
      getNovelName.messeage = "Type Novel's Name..."
      getNovelName.callback = (name)->
        _open(name)
      getNovelName.show()
    else _open(name)




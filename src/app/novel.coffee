wl.novel =
  open: (novelname)->
    unless novelname?
      getNovelName = new wl.popup("prompt")

    wl.novel.name = novelname
    wl.novel.path = novelpath =path.join(wl.bookshalf.path,novelname)
    index = JSON.parse(fs.readFileSync(path.join(novelpath,"index.json"),"utf-8"))
    $.extend wl.novel,index
    wl.chapter.forEach (item,index)->
      $("#chapter-list").append "<li oncick='wl.novel.chapter.open(#{item})'>#{item}</li>"


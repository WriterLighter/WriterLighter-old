wl.novel =
  chapter:
    open: (number) ->
      if wl.menu.contextmenuEvent?
        number = wl.menu.contextmenuEvent.target.dataset.chapter
      if wl.editor.edited then wl.novel.chapter.save()
      _open = (path) ->
        fs.readFile path, 'utf8', (e, t)->
          $("#chapter .opened").removeClass "opened"
          wl.novel.chapter.path = path
          wl.editor.previousInput = wl.novel.previousFile = if t? then t else ""
          $("#input-text").text(wl.novel.previousFile)
          wl.editor.edited = false
          wl.novel.chapter.opened = number
          wl.lastedit.save()
          $("#chapter [data-chapter='#{number}']").addClass("opened")
          wl.editor.clearWindowName()
          wl.statusbar.reload()

      unless isNaN(number - 0)
        number = number % wl.novel.chapter.list.length
        number = if number < 0 then -number else number
        _open(path.join(wl.novel.path,"/本文/",wl.novel.chapter.list[number] + ".txt"))
      else if number? and number isnt ""
        switch number
          when "next"
            unless isNaN(wl.novel.chapter.opened)
              wl.novel.chapter.open(wl.novel.chapter.opened - 0 + 1)
          when "back"
            unless isNaN(wl.novel.chapter.opened)
              wl.novel.chapter.open(wl.novel.chapter.opened - 1)
          else
            _open(path.join(wl.novel.path,wl.novel[number].path))

      else
        getChapter = new wl.popup("prompt")
        getChapter.messeage = "章名またはタイプ(afterwordなど)を入力…"
        getChapter.callback = (chapter)->
          wl.novel.chapter.open(chapter)
        getChapter.show()

    new: (name)->
      if name? and name isnt ""
        newchapter = wl.novel.chapter.list.push name
        $("#input-text").text("")
        wl.editor.previousInput = wl.novel.previousFile = ""
        wl.novel.chapter.opened = newchapter - 1
        wl.editor.edited = false
        wl.novel.chapter.reload()
        wl.novel.chapter.path = path.join(wl.novel.path,"本文",name+".txt")
        wl.novel.saveIndex()
        wl.lastedit.save()
      else
        getNewChapterName = new wl.popup("prompt", "追加する章名を入力…")
        getNewChapterName.callback = (name)->
          wl.novel.chapter.new(name)
        getNewChapterName.show()

    rename: (number) ->
      unless isNaN(number - 0)
        confirm = new wl.popup "prompt"
        confirm.messeage = "新しい章名を入力してください…"
        confirm.callback = (name) ->
          oldname = wl.novel.chapter.list[number]
          newpath = wl.novel.chapter.path =  path.join(wl.novel.path, "本文", name + ".txt")
          fs.renameSync path.join(wl.novel.path, "本文", oldname + ".txt"), newpath
          wl.novel.chapter.list[number] = name
          wl.novel.saveIndex()
          wl.novel.chapter.reload()
          if wl.novel.chapter.opened is number
            wl.chapter.open number
        confirm.show()
      else
        getChapter = new wl.popup("prompt")
        getChapter.messeage = "章名またはタイプ(afterwordなど)を入力…"
        getChapter.callback = (chapter)->
          wl.novel.chapter.rename(chapter)
        getChapter.show()

    delete: (number) ->
      unless isNaN(number - 0)
        confirm = new wl.popup "prompt"
        confirm.messeage = "確認のため、章名をご入力ください…"
        confirm.callback = (name) ->
          if name is wl.novel.chapter.list[number]
            wl.novel.chapter.list.splice number, 1
            fs.unlink path.join(wl.novel.path, "本文", name + ".txt")
            wl.novel.saveIndex()
            wl.novel.chapter.reload()
            if wl.novel.chapter.opened is number
              wl.chapter.open 1
          else
            wl.novel.chapter.delete number
        confirm.show()
      else
        getChapter = new wl.popup("prompt")
        getChapter.messeage = "章名またはタイプ(afterwordなど)を入力…"
        getChapter.callback = (chapter)->
          wl.novel.chapter.delete(chapter)
        getChapter.show()

    save: ->
      fs.writeFile wl.novel.chapter.path, wl.editor.input.innerText, (e)->
        if e?
          errp = new wl.popup("toast", e)
          errp.show()
        else
          wl.novel.previousFile = wl.editor.input.innerText
          wl.editor.edited = false
          wl.editor.clearWindowName()

    reload: ->
      list = ""
      wl.novel.chapter.list.forEach (item,index)->
        list +=  "<li data-chapter='#{index}' data-context='chapter_list'>#{item}</li>"
      $("#chapter-list").html(list)
      $("[data-chapter]").on "click", (e)->
        wl.novel.chapter.open this.dataset.chapter

  description:{}
  afterword:{}
  plot:{}
  open: (name)->

    _open =  (novelname)->
      wl.novel.name = novelname
      wl.novel.path = novelpath =path.join(wl.config.user.bookshalf,novelname)
      index = JSON.parse(fs.readFileSync(path.join(novelpath,"index.json"),"utf-8"))
      wl.novel.chapter.list = index.chapter
      wl.novel.description.path = index.description
      wl.novel.afterword.path = index.afterword
      wl.novel.author = index.author
      wl.novel.plot.path = index.plot
      wl.novel.chapter.reload()
      if index.chapter.length is 0 then wl.novel.chapter.new() else wl.novel.chapter.open(0)

    if name? and name isnt ""
      _open name
    else
      getNovelName = new wl.popup("prompt")
      getNovelName.messeage = "小説名を入力…"
      getNovelName.callback = (name)->
        wl.novel.open name
      getNovelName.complete = wl.novel.list
      getNovelName.show()

  saveIndex: ->
    index =
      name: wl.novel.name
      chapter: wl.novel.chapter.list
      description: wl.novel.description.path
      afterword: wl.novel.afterword.path
      author: wl.novel.author
      plot: wl.novel.plot.path
    console.log index
    
    fs.writeFile path.join(wl.novel.path, "index.json"), JSON.stringify(index), (e)->
      if e? then console.error e

  new: (name)->
    if name? and name isnt ""
      index =
        name: name
        author: wl.config.user.name
        description: "説明.txt"
        afterword: "あとがき.txt"
        chapter: []
        plot: "プロット.txt"

      fs.mkdirs path.join(wl.config.user.bookshalf, name, "本文"), (e)->
        unless e?
          fs.writeFile path.join(wl.config.user.bookshalf, name, "index.json"), JSON.stringify(index), (e)->
            unless e?
              wl.novel.open name
    else
      p = new wl.popup("prompt", "小説名を入力…")
      p.callback = (name)->
        wl.novel.new name
      p.show()
path     = require 'path'
mkdirp   = require 'mkdirp'
glob     = require 'glob'
fs       = require 'fs'

module.exports = class novel
  novelPath = ""
  novelName = ""
  chapterPath = ""
  chapterNumber = 0
  novelIndex = {}
  originalFile = ""

  @getIndex = ->
    novelIndex
  @openChapter = (number) ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapter
    if editor.isEdited() then novel.save()

    _open = (cpath) ->
      fs.readFile cpath, 'utf8', (e, t)->
        do (new Popup "toast",e).show if e?
        $("#chapter .opened").removeClass "opened"
        chapterPath = cpath
        text = if t? then t else ""
        editor.setText text
        chapterNumber = number
        lastedit.save()
        $("#chapter [data-chapter='#{(if isNaN number then number else number + 1)}']").addClass "opened"
        event.fire "openedChapter"
        do editor.clearWindowName
        do counter.count

    unless isNaN(number)
      number = number - 1 % novelIndex.chapter.length
      _open(path.join(novelPath, "本文", novelIndex.chapter[number] + ".txt"))
    else if number? and number isnt ""
      switch number
        when "next"
          unless isNaN chapterNumber
            novel.openChapter chapterNumber - 0 + 1
        when "back"
          unless isNaN chapterNumber
            novel.openChapter chapterNumber - 1
        else
          _open(path.join(novelPath, novelIndex[number]))

    else
      getChapter = new Popup("prompt")
      getChapter.messeage = "章名またはタイプ(afterwordなど)を入力…"
      getChapter.callback = novel.openChapter
      getChapter.show()

  @newChapter: (name)->
    if name? and name isnt ""
      newchapter = novelIndex.chapter.push name
      editor.setHTML ""
      originalFile = ""
      chapterNumber = newchapter
      do novel.reloadChapterList
      chapterPath = path.join(novelPath,"本文",name+".txt")
      novel.saveIndex()
      lastedit.save()
    else
      getNewChapterName = new Popup("prompt", "追加する章名を入力…")
      getNewChapterName.callback = novel.newChapter
      getNewChapterName.show()

  @renameChapter: (number) ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapter
    unless isNaN(number)
      number--
      confirm = new Popup "prompt"
      confirm.messeage = "新しい章名を入力してください…"
      confirm.callback = (name) ->
        oldFile = if number is chapterNumber
          chapterPath
        else
          path.join novelPath, "本文", novelIndex.chapter[number] + ".txt"
        chapterPath =  path.join novelPath, "本文", name + ".txt"
        fs.renameSync oldFile, chapterPath
        novelIndex.chapter[number] = name
        novel.saveIndex()
        novel.reloadChapterList()
        if chapterNumber is number
          novel.openChapter number + 1
      confirm.show()
    else
      getChapter = new Popup("prompt")
      getChapter.messeage = "章番号を入力…"
      getChapter.callback = novel.renameChapter
      getChapter.show()

  @deleteChapter: (number) ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapter
    unless isNaN number
      number--
      confirm = new Popup "prompt"
      confirm.messeage = "確認のため、章名を入力ください…"
      confirm.callback = (name) ->
        if name is novelIndex.chapter[number]
          novelIndex.chapter.splice number, 1
          fs.unlink path.join novelPath, "本文", name + ".txt"
          novel.saveIndex()
          novel.reloadChapterList()
          if chapterNumber is number
            novel.openChapter 1
        else
          novel.deleteChapter number
      confirm.show()
    else
      getChapter = new Popup("prompt")
      getChapter.messeage = "章番号を入力…"
      getChapter.callback = novel.deleteChapter
      getChapter.show()

  @save: ->
    fs.writeFile chapterPath, editor.getText(), (e)->
      if e?
        errp = new Popup("toast", e)
        errp.show()
      else
        event.fire "savedChapter"
        editor.clearWindowName()

  @reloadChapterList: ->
    list = ""
    novelIndex.chapter.forEach (item,index)->
      list +=  "<li data-chapter='#{(index + 1)}' data-context='chapter_list'>#{item}</li>"
    $("#chapter-list").html(list)
    $("[data-chapter]").on "click", (e)->
      novel.openChapter this.dataset.chapter

  @openNovel: (name) ->
    _open =  (novelname)->
      novelName = novelname
      novelPath = path.join config.get("bookshalf"), novelname
      novelIndex = JSON.parse(fs.readFileSync(path.join(novelPath,"index.json"),"utf-8"))
      novel.reloadChapterList()
      event.fire "openedNovel"
      if novelIndex.chapter.length is 0 then novel.newChapter() else novel.openChapter 0

    if name? and name isnt ""
      _open name
    else
      getNovelName = new Popup("prompt")
      getNovelName.messeage = "小説名を入力…"
      getNovelName.callback = novel.openNovel
      getNovelName.complete = novel.getNovelList()
      getNovelName.show()

  @getNovelList = ->
    glob path.join(config.get("bookshalf"),"*","index.json"), (e,d)->
      list = []
      d.forEach (item,index)->
        list.push path.basename(path.dirname(item))
      list

  @getOpened = ->
    novel:
      path: novelPath
      name: novelName
    chapter:
      index: chapterNumber
      name : path.parse(chapterPath).name

  @saveIndex: ->
    fs.writeFile path.join(novelPath, "index.json"), JSON.stringify(novelIndex), (e)->
      if e? then (new Popup "toast", e).show()

  @newNovel: (name)->
    if name? and name isnt ""
      index =
        name: name
        author: config.get "name"
        description: "説明.txt"
        afterword: "あとがき.txt"
        chapter: []
        plot: "プロット.txt"
      novelpath = path.join config.get("bookshalf"), name

      mkdirp path.join(novelpath, "本文"), (e)->
        unless e?
          fs.writeFile path.join(novelpath, "index.json"), JSON.stringify(index), (e)->
            unless e?
              novelPath = novelpath
              novel.openNovel name
    else
      p = new Popup("prompt", "小説名を入力…")
      p.callback = novel.newNovel
      p.show()

Popup    = require './popup'
menu     = require './menu'
editor   = require './editor'
lastedit = require './lastedit'
config   = require './config'
counter  = require './counter'
event    = require './event'

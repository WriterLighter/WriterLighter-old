path     = require 'path'
mkdirp   = require 'mkdirp'
glob     = require 'glob'
fs       = require 'fs'

module.exports = class novel
  opened =
    novel:
      path: ""
      name: ""
    chapter:
      index: 0
      type: ""
      name: ""

  novelIndex = {}
  originalFile = ""

  getChapterPath = (index, type="body") ->
    if novelIndex[type]?
      throw new Error "Bad chapter type"
    if novelIndex[type][index]?
      throw new Error "This index chapter is not existed."
    path.join novelPath, type, "#{novelPath[type][index]}.txt"


  @getIndex = ->
    novelIndex

  @openChapter = (number, type="body") ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapterNumber
      type   = __menu.contextMenuEvent.target.dataset.chapterType
    if editor.isEdited() then novel.save()

    if number?
      switch number
        when "next"
          novel.openChapter opened.chapter.type,
            opened.chapter + 1 % novelIndex.chapter.length
        when "back"
          novel.openChapter opened.chapter.type,
            opened.chapter - 1 % novelIndex.chapter.length
        else
          try
            chapterPath = getChapterPath number, type
          catch e
            do (new Popup(e.messeage)).show

          try
            text = fs.readFileSync chapterPath, 'utf8'

          $("#chapter .opened").removeClass "opened"
          opened.chapter.path = chapterPath
          text = text or ""
          editor.setText text
          opende.chapter.index = number
          do lastedit.save
          $("#chapter [data-chapter-number='#{(number)}'] \
            [data-chapter-type='#{type}']").addClass "opened"
          event.fire "openedChapter"
          do editor.clearWindowName
          do counter.count
    else
      getChapter = new Popup("prompt")
      getChapter.messeage = ["章番号を入力…", "タイプを入力…"]
      getChapter.callback = (value)->
        novel.openChapter.call novel, value
      do getChapter.show

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
      novelIndex = YAML.load(fs.readFileSync(path.join(novelPath,"index.yml"),"utf-8"))
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
    glob path.join(config.get("bookshalf"),"*","index.yml"), (e,d)->
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
    fs.writeFile path.join(novelPath, "index.yml"), YAML.dump(novelIndex), (e)->
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
          fs.writeFile path.join(novelpath, "index.yml"), YAML.dump(index), (e)->
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

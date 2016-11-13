path     = require 'path'
mkdirp   = require 'mkdirp'
glob     = require 'glob'
fs       = require 'fs-extra'
YAML     = require 'js-yaml'

module.exports = class novel
  opened =
    novel:
      path: ""
      name: ""
    chapter:
      number: 0
      type: ""
      name: ""

  novelIndex   = {}
  originalFile = ""
  chapterList  =
    body: $ "#chapter-list-body"
    metadata: $ "#chapter-list-metadata"

  for type, $el of chapterList
    $el.on "click", "li", (e)->
      novel.openChapter @dataset.chapterNumber, @dataset.chapterType

  getChapterPath = (number, type="body", name) ->
    if number is "now"
      {number, type} = opened.chapter

    index = number - 1

    unless novelIndex[type]?
      throw new Error "Bad chapter type"

    unless novelIndex[type][index]?
      throw new Error "This index chapter is not existed."
    
    name = name or novelIndex[type][index]

    path.join opened.novel.path, type, "#{number}_#{name}.txt"

  @getChapterPath = ->
    getChapterPath.apply @, arguments

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
          {number, type} = opened.chapter
          number = number % novelIndex[type].length + 1
        when "back"
          {number, type} = opened.chapter
          number = (number - 1) % novelIndex[type].length
          number = novelIndex[type].length unless number > 0

      try
        chapterPath = getChapterPath number, type
      catch e
        new Popup messeage: e

      try
        text = fs.readFileSync chapterPath, 'utf8'
      catch e
        if e.code is 'ENOENT'
          text = ""
        else
          throw e
      $("#chapter .opened").removeClass "opened"
      editor.setText text
      originalFile = text
      opened.chapter =
        number: number
        type: type
        name: novelIndex[type][number - 1]
        path: chapterPath
      do lastedit.save
      $("#chapter [data-chapter-number='#{(number)}'][data-chapter-type='#{type}']")
        .addClass "opened"
      event.fire "openedChapter"
      do editor.clearWindowName
      do counter.count
    else
      getChapter = new Popup
        type: "prompt"
        messeage: ["章番号を入力…", "タイプを入力…"]
      getChapter.on "hide", (value)->
        novel.openChapter.call novel, value
      do getChapter.show

  @newChapter: (name="名称未設定", type=opened.chapter.type, index=novelIndex[type].length + 1)->
    index = novelIndex[type].splice index, 0, name
    novel.open index
    do novel.reloadChapterList
    do novel.saveIndex
    do lastedit.save

  @renameChapter: (number=opened.chapter.number, type=opened.chapter.type, name) ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapterNumber
    if name
      fs.renameSync getChapterPath("now"), getChapterPath(number, type, name)
      novelIndex[type][number - 1] = name
    else
      prompt = new Popup
        type:"prompt"
        messeage: "新しい章名を入力してください…"

      prompt.on "hide", (name) ->
        novel.renameChapter number, type, name

  @deleteChapter: (number=opened.chapter.number, type=opened.chapter.type) ->
    if __menu? and __menu.contextMenuEvent?
      number = __menu.contextMenuEvent.target.dataset.chapterNumber
      type   = __menu.contextMenuEvent.target.dataset.chapterType
    index = number - 1
    name = novelIndex[type][chapter]
    confirm = new Popup
      type: "prompt"
      messeage: "#{name}を削除します。確認のため、章名を入力してください…"
    confirm.on "hide", (res) ->
      if res is name
        fs.unlinkSync getChapterPath number, type
        novelIndex.chapter.splice number, 1
        do novel.saveIndex
        do novel.reloadChapterList
        if chapterNumber is number
          novel.openChapter 1
      else
        novel.deleteChapter number, type

  @save: ->
    fs.writeFile getChapterPath("now"), editor.getText(), (e)->
      if e?
        errp = new Popup messeage: e
        errp.show()
      else
        event.fire "savedChapter"
        editor.clearWindowName()

  @reloadChapterList: ->
    for type, $el of chapterList
      list = ""
      for name, i in novelIndex[type]
        list +=  "<li data-chapter-number='#{(i + 1)}'
        data-chapter-type='#{type}' data-context='chapter_list'>#{name}</li>"
      $el.html list

  @openNovel: (name) ->
    if name? and name isnt ""
      opened.novel =
        name: name
        path: path.join config.get("bookshalf"), name
      novelIndex = YAML.load(fs.readFileSync(path.join(opened.novel.path,"index.yml"),"utf-8"))
      novel.reloadChapterList()
      event.fire "openedNovel"
      unless novelIndex.body.length
        novel.newChapter "名称未設定", "body"
      else
        novel.openChapter 1, "body"
    else
      getNovelName = new Popup
        type: "prompt"
        messeage: "小説名を入力…"
        complete: novel.getNovelList()
      getNovelName.on "hide", novel.openNovel

  @getNovelList = ->
      for index in glob.sync path.join(config.get("bookshalf"),"*","index.yml")
        path.basename path.dirname index

  @getOpened = ->
    opened

  @saveIndex: ->
    fs.writeFile path.join(opened.novel.path, "index.yml"), YAML.dump(novelIndex), (e)->
      if e? then new Popup messeage: e

  @newNovel: (name)->
    if name
      index =
        name: name
        author: config.get "user-name"
        metadata: ["プロット"]
        chapter: []
      novelpath = path.join config.get("bookshalf"), name

      if not mkdirp.sync(path.join(novelpath, "body")) and
          not mkdirp.sync(path.join(novelpath, "metadata"))
        fs.writeFileSync path.join(novelpath, "index.yml"), YAML.dump(index)
        novel.openNovel name
    else
      p = new Popup
        type: "prompt"
        messeage: "小説名を入力…"
      p.on "hide", novel.newNovel

Popup    = require './popup'
menu     = require './menu'
editor   = require './editor'
lastedit = require './lastedit'
config   = require './config'
counter  = require './counter'
event    = require './event'

path = require 'path'
app  = require('electron').remote.app
dialog = require('electron').dialog
fs   = require 'fs'

module.exports = class config
  configs = {}
  configFile = path.join app.getPath("userData"), "config.json"
  merge = (object, override = false) =>
    if override then $.extend(configs, object) else $.extend(true, configs, object)

  @save = ->
    unless Object.keys(configs).length
      try
        fs.writeFileSync configFile, JSON.stringify(configs)
        return configs
      catch
        return {}

  @load = ->
    fs.readFile configFile, (err,data)->
      if not err? and data? and Object.keys(data).length isnt 0
        configs = JSON.parse data
      else
        do config.init

  @get = (name)->
    names = name.split '.'
    res = null unless configs[names[0]]?
    res =  config.get(names.slice(1).join('.'), configs[names[0]]) if names.length > 1
    res = configs[names[0]]
    res
    
  @set= (name, val, override = false) =>
    names = name.split '.'
    obj   = {}
    elm   = obj

    for key, i in names
      elm[key] = if i == names.length - 1 then val else {}
      elm = elm[key]

    merge obj, override
    val


  @init= ->
# TODO: 「はじめる(名称仮)」作る
    ###
    # 初回起動時に開く
    fs.copySync path.join(__dirname, "はじめまして"), bookshalf.path
    novel.open("はじめまして")
    ###
    bspath = path.join app.getPath("documents"), "Novels"
    modal = new ModalWindow("ようこそ！")
    modal.content = fs.readFileSync("welcome.html").toString()
    modal.forcing = true
    modal.show()
    $("form#welcome [name='bookshalf']").val bspath
    $("form#welcome [name='browse']").on "click", ->
      selectedpath = dialog.showOpenDialog
        properties: ['oepnDirectory','createDirectory']
        defaultPath: $("form#welcome [name='bookshalf']").val()
      if selectedpath?
        $("form#welcome [name=bookshalf]").val selectedpath
    $("form#welcome").on "submit", ->
      configs.name = $("form#welcome [name='name']").val()
      configs.bookshalf = $("form#welcome [name='bookshalf']").val()
      $("#modal-window").removeClass "show"
      do config.save
      return false

ModalWindow = require "./modalwindow"

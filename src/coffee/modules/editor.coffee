BrowserWindow = require("electron").remote.BrowserWindow
event   = require './event'

$input = $ "#input-text"

edited = false
previousInput = ""
saveTimeout = null
pressedKey = 0
_onchange = ->
  text = do editor.getText
  if text isnt previousInput
    if edited is false
      edited = true
      document.title = "* " + document.title
    saveTimeout? and clearTimeout saveTimeout

    lines = text.split '\n'
    preLines = previousInput.split "\n"
    if pressedKey is 13 and lines.length > preLines.length
      range = null
      range = document.createRange()
      range.setStart $input[0], 0
      range.setEnd getSelection().anchorNode, 0
      beforeCaret = range.toString().length
      charaNum = 0
      for line, idx in preLines
        charaNum += line.length
        if charaNum >= beforeCaret
          match = preLines[idx - 1].match /^([\s　]+).+$/
          break
      if match?
        document.execCommand 'insertHTML', false, do match.pop

    do counter.count
    previousInput = text
    wl.editor.saveTimeout = setTimeout wl.novel.save
    , unless isNaN config.get("saveTimeout") then config.get "saveTimeout" else 3000

module.exports = class editor
  
  #editorMode
  #0:標準モード
  #1:超集中モード
  editorMode = ""

  @setMode = (mode) ->
    switch mode
      when "default"
        wl.layout.open("west")
        wl.layout.open("east")
        wl.layout.open("south")
        BrowserWindow.getFocusedWindow().setFullScreen(false)
        editorMode = mode
        new Popup messeage: "モード:標準"
  
      when "intensive"
        wl.layout.hide("west")
        wl.layout.hide("east")
        wl.layout.hide("south")
        BrowserWindow.getFocusedWindow().setFullScreen(true)
        editorMode = mode
        new Popup messeage: "モード:超集中モード"
  
  @toggleMode = ->
    switch editorMode
      when "default"
          editor.setMode "intensive"
      when "intensive"
          editor.setMode "default"
      else
          editor.setMode "default"

  @getMode = ->
    editorMode

  @setDirection: (direction)->
    switch direction
      when "vertical"
        $input.addClass("vertical")
      when "horizontal"
        $input.removeClass("vertical")
      else
        editor.setDirection("horizontal")

  @getDirection= ->
    if $input.hasClass "vertical" then "vertical" else "horizontal"

  @toggleDirection: ->
    if do editor.getDirection is "vertical"
      editor.setDirection "horizontal"
    else
      editor.setDirection "vertical"

  @clearWindowName = ->
    opened = do novel.getOpened
    document.title = "#{opened.chapter.name} - #{opened.novel.name} | WriterLighter"

  @setText = (text, sync=yes) ->
    $input[0].innerText = text
    _onchange sync

  @setHTML = (html, sync=yes)->
    $input[0].innerHTML = html
    if sync
      editor.setText do editor.getText, no

  @getText = ->
    $input[0].innerText

  @getHTML = ->
    $input[0].innerHTML

  @isEdited = ->
    edited

  @getDOMObject = ->
    $input[0]

  @undo = ->
    document.execCommand "undo"

  @redo = ->
    document.execCommand "redo"

$input.on "input", _onchange

$input.on "keydown", (e)->
  pressedKey = e.keyCode

event.on "savedChapter openedChapter", ->
  edited = false

Popup   = require "./popup"
novel   = require "./novel"
counter = require "./counter"
config  = require "./config"

currentWindow = do require("electron").remote.getCurrentWindow
event   = require './event'

$input = $ "#input-text"
$wrapper = $ "#editor-wrap"

edited = false
previousInput = ""
saveTimeout = null
pressedKey = 0
beforeCaret = ""

updateBeforeCaret = (e)->
  unless $input.is document.activeElement
    return

  sel = do getSelection

  range = do document.createRange
  range.setStart $input[0], 0
  range.setEnd sel.anchorNode, sel.anchorOffset

  beforeCaret = range.toString().replace /\n/g , ""

  l = 0
  for line in editor.getText().split "\n"
    l += line.length
    if l >= beforeCaret.length then break
    beforeCaret = "#{beforeCaret.slice 0,l}\n#{beforeCaret.slice l}"
    l++

_onchange = ->
  do updateBeforeCaret

  text = do editor.getText
  if text isnt previousInput
    if edited is false
      edited = true
      document.title = "* " + document.title
    saveTimeout? and clearTimeout saveTimeout

    if pressedKey is 13 and
    text.split("\n").length > previousInput.split("\n").length

      match = beforeCaret.match /^[ 　\t]+/gm
      if match?
        document.execCommand 'insertHTML', false, do match.pop

    do counter.count
    previousInput = text
    saveTimeout = setTimeout novel.save
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
        currentWindow.setFullScreen(false)
        editorMode = mode
        new Popup messeage: "モード:標準"
  
      when "intensive"
        wl.layout.hide("west")
        wl.layout.hide("east")
        wl.layout.hide("south")
        currentWindow.setFullScreen(true)
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
        $wrapper.addClass("vertical")
      when "horizontal"
        $wrapper.removeClass("vertical")
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

  @setText = (text) ->
    $input[0].innerText = text
    _onchange

  @getText = ->
    $input[0].innerText

  @isEdited = ->
    edited

  @getDOMObject = ->
    $input[0]
    
  @getBeforeCaret = ->
    beforeCaret

  @undo = ->
    document.execCommand "undo"

  @redo = ->
    document.execCommand "redo"

$input.on "keydown keyup click", updateBeforeCaret

$input.on "input", _onchange

$input.on "keydown", (e)->
  pressedKey = e.keyCode

novel.on "savedChapter", ->
  edited = false

novel.on "openedChapter", ->
  edited = false

Popup   = require "./popup"
novel   = require "./novel"
counter = require "./counter"

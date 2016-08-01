BrowserWindow = require("electron").remote.BrowserWindow

$input = $ "#input-text"

edited = false
previousInput = ""
saveTimeout = null
_onchange = ->
  if editor.getText() isnt previousInput
    if edited is false
      edited = true
      document.title = "* " + document.title
    saveTimeout? and clearTimeout saveTimeout
    do counter.count
    previousInput = do editor.getText
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
        wl.layout.open("south")
        BrowserWindow.getFocusedWindow().setFullScreen(false)
        editorMode = mode
        (new Popup 'toast', "モード:標準").show()
  
      when "intensive"
        wl.layout.hide("west")
        wl.layout.hide("south")
        BrowserWindow.getFocusedWindow().setFullScreen(true)
        editorMode = mode
        (new Popup 'toast', "モード:超集中モード").show()
  
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

  @setText = (text) ->
    $input[0].innerText = text
    do _onchange

  @setHTML = (html)->
    $input[0].innerHTML = html
    do _onchange

  @getText = ->
    $input[0].innerText

  @getHTML = ->
    $input[0].innerHTML

  @isEdited = ->
    edited

  @getDOMObject = ->
    $input[0]

$input.on "input", _onchange

$input.on "keydown", (e)->
  if e.keyCode is 13 and editor.getText().split("\n").length > previousInput.split("\n").length
    document.execCommand('insertHTML', false, '　')

Popup         = require "./popup"
novel         = require "./novel"
counter       = require "./counter"
config        = require "./config"


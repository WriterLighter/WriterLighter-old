BrowserWindow = require("electron").remote.BrowserWindow
Popup         = require "./popup"
novel         = require "./novel"

$input = $ "#input-text"

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

$("#input-text").on "input", (e)->
  if wl.editor.edited is false
    wl.editor.edited = true
    document.title = "* " + document.title
  clearTimeout wl.editor.saveTimeout
  wl.statusbar.reload()
  wl.editor.previousInput = wl.editor.input.innerText
  wl.editor.saveTimeout = setTimeout ()->
    wl.novel.chapter.save()
  , if typeof wl.config.user.saveTimeout is "number" then wl.config.user.saveTimeout else 1000

$("#input-text").on "keyup", (e)->
  if e.keyCode is 13 and wl.editor.input.innerText.split("\n").length = wl.editor.previousInput.split("\n").length
    document.execCommand('insertHTML', false, '　')

$(window).on "beforeunload" , ()->
  if wl.editor.edited then wl.novel.chapter.save()

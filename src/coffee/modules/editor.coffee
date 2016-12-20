currentWindow = do require("electron").remote.getCurrentWindow
event   = require './event'

$input = $ "#input-text"
$wrapper = $ "#editor-wrap"
$highlights = $ "#highlights"
$highlightBase = $ "#highlight-base"

edited = false
previousInput = ""
saveTimeout = null
pressedKey = 0
beforeCaret = ""

highlights = {}

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
    $highlightBase[0].innerHTML = text
    do editor.highlight
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

  @setAutoHighlighter = (id, changeValue)->
    throw new Error "id is a required argument" unless id?

    unless highlights[id]? and highlights[id].element?
      highlights[id] = {}
      el = document.createElement "pre"
      $highlights.append el
    else
      el = highlights[id].element

    Object.assign highlights[id], changeValue

    el.style.display =
    unless highlights[id].enabled and highlights[id].rule then "none" else ""

    highlights[id].element = el

    editor.highlight id

  @highlight = (id) ->
    text = do editor.getText

    _highlight = (id) ->
      setting = highlights[id]
      rule = setting.rule

      enabled = setting.enabled ? true

      unless enabled and rule
        setting.element.style.display = "none"
      else
        setting.element.style.display = ""

      if Object::toString.call(rule) is "[object String]"
        rule = new RegExp rule.replace(/[\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|\/]/g, "\\$&"), "g"

      setting.element.innerHTML =
      text.replace rule, setting.replacement ? "<mark class='hl-#{id}'>$&</mark>"

      $ setting.element
      .children ".hl-#{id}"

    if id?
      _highlight id
    else
      for k of highlights
        _highlight k

  @clearWindowName = ->
    opened = do novel.getOpened
    document.title = "#{opened.chapter.name} - #{opened.novel.name} | WriterLighter"

  @setText = (text) ->
    $input[0].innerText = text
    do _onchange

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

$input.on "paste", (e)->
  do e.preventDefault

  document.execCommand "insertHTML", no,
    e.originalEvent.clipboardData.getData "text/plain"

Popup   = require "./popup"
novel   = require "./novel"
counter = require "./counter"
config  = require "./config"

novel.on "savedChapter", ->
  edited = false

novel.on "openedChapter", ->
  edited = false

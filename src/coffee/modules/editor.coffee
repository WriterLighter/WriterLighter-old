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

autoHighlights = {}
highlightElements = {}

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

  createHighlight = (match, message) ->
    lines = match
    .input
    .slice 0,  match.index
    .split "\n"

    typeOfMessage = Object::toString.call message

    message = if typeOfMessage is "[object String]"
      message.replace /\$([$&`']|[0-9]+)/, (m, $0) ->
        if isNaN $0
          switch $0
            when "$"
              "$"
            when "&"
              match[0]
            when "`"
              match.input.slice 0, match.index
            when "'"
              match.input.slice match.index + match[0].length
        else
          match[$0]
    else if typeOfMessage is "[object Function]"
      match.push match.index, match.input
      message.apply editor, match
    else
      undefined

    line: lines.length
    column: lines.pop().length
    index: match.index
    message: message

  @markAutoHighlights = (id="all")->
    _mark = (id) ->
      highlight = autoHighlights[id]
      indices = []
      if Object::toString.call(rule = highlight.rule) is "[object String]"
        length = rule.length
        startIndex = 0
        while (index = src.indexOf rule, startIndex) > -1
          match = [rule]
          match.index = index
          match.input = src
          indices.push createHighlight match, highlight.message
          startIndex = index + length
      else
        while (match = rule.exec src)? and (rule.global or indices.length is 0)
          indices.push createHighlight match, highlight.message

      editor.highlight id indices

    if id is "all"
      for id of autoHighlights
        _mark id
    else
      _markd id

  @setAutoHighlighter = (id, changeValue)->
    throw new Error "id is a required argument" unless id?
    if autoHighlights[id]?
      autoHighlights[id] = {}

    Object.assign autoHighlights[id], changeValue

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

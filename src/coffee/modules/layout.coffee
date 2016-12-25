currentWindow = do require("electron").remote.getCurrentWindow

$container = $ "#container"
$footer = $ "footer"

panes =
  east: $ "#pane-east"
  west: $ "#pane-west"

$panes = $ ".pane"

resizers = {}

resizing = null
beforeX = 0

setResizerPosition = (pane) ->
  w = do panes[pane].innerWidth
  resizers[pane].css if pane is "east"
    left: w
  else
    right: w

startResize = (e)->
  beforeX = e.pageX
  resizing = $(@).data "direction"

for dir, $pane of panes
  resizers[dir] = $ "<div class='pane-resizer'></div>"
  .appendTo $container
  .on "mousedown", startResize
  .data "direction", dir

  setResizerPosition dir

$container
.on "mousemove", (e) ->
  unless resizing?
    return

  do e.preventDefault

  resize = e.pageX - beforeX
  beforeX = e.pageX

  if resizing is "west"
    resize = -resize

  layout.resizePane resizing, "+=" + resize, animate: false

.on "mouseup mouseleave", ->
	resizing = null
getWidth = ($el) ->

  if $el.css("box-sizing") is "border-box"
    do $el.innerWidth
  else
    do $el.width

state =
  west:
    beforeWidth: getWidth panes.west
    show: yes
  east:
    beforeWidth: getWidth panes.east
    show: yes

getTargetPane = (pane="all") ->
  if pane is "all"
    $panes
  else panes[pane]

module.exports = class layout
  @resizePane: (pane="all", size=0, option={})->
    fitResizer = ->
      if pane isnt "west"
        setResizerPosition "east"
      if pane isnt "east"
        setResizerPosition "west"

    option = Object.assign
      relative: false
      animate: true
      duration: 50
    ,option

    if option.relative
      size = "+=" + size

    getTargetPane pane
    .animate {width: size},
    duration:
      if option.animate
        option.duration
      else
        0
    , step: if option.animate
      fitResizer
    , complete: option.complete

    unless option.animate
      do fitResizer

  @hidePane: (pane="all") ->
    _hide = (pane) ->
      if state[pane].show
        state[pane].show = no
        state[pane].width = getWidth panes[pane]
        layout.resizePane pane, 0, complete: ->
          do panes[pane].hide
          do resizers[pane].hide

    if pane is "west" or pane is "east"
      _hide pane
    else if pane is "all"
      _hide "west"
      _hide "east"
    else
      throw new Error "invalid value"

  @showPane: (pane="all") ->
    _show = (pane) ->
      unless state[pane].show
        state[pane].show = yes
        layout.resizePane pane, state[pane].width, complete: ->
          do panes[pane].show
          do resizers[pane].show

    if pane is "west" or pane is "east"
      _show pane
    else if pane is "all"
      _show "west"
      _show "east"
    else
      throw new Error "invalid value"

  #layoutMode
  #0:標準モード
  #1:超集中モード
  layoutMode = ""

  @setMode = (mode) ->
    switch mode
      when "default"
        layout.showPane "all"
        do $footer.show
        currentWindow.setFullScreen no
        layoutMode = mode
        new Popup messeage: "モード:標準"
  
      when "intensive"
        layout.hidePane "all"
        do $footer.hide
        currentWindow.setFullScreen yes
        layoutMode = mode
        new Popup messeage: "モード:超集中モード"
  
  @toggleMode = ->
    switch layoutMode
      when "default"
          layout.setMode "intensive"
      when "intensive"
          layout.setMode "default"
      else
          layout.setMode "default"

  @getMode = ->
    layoutMode

Popup = require "./popup"

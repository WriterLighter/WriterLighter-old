$body = $ "body"

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
  .appendTo $body
  .on "mousedown", startResize
  .data "direction", dir

  setResizerPosition dir

$body
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
    open: yes
  east:
    beforeWidth: getWidth panes.east
    open: yes

getTargetPane = (pane="all") ->
  if pane is "all"
    $panes
  else panes[pane]

module.exports = class layout
  @hidePane: (pane="all") ->
    _hide = (pane) ->
      if state[pane].open
        state[pane].open = no
        state[pane].width = getWidth panes[pane]
        panes[pane].animate width: 0, 50, -> do panes[pane].hide

    if pane is "west" or pane is "east"
      _hide pane
    else if pane is "all"
      _hide "west"
      _hide "east"
    else
      throw new Error "invalid value"


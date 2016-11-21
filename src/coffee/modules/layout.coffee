panes =
  east: $ "#pane-east"
  west: $ "#pane-west"

$panes = $ ".pane"

$handles = $ "<div class='pane-resizer'>"
.appnedTo ".pane"
.on "mousedown", (e)->
  beforeX = e.pageX
  resizing = $ @
  .closest ".pane"
  .attr "id"
  .slice 5

$ "body"
.on "mousemove", (e) ->
  unless resizing?
    return

  do e.preventDefault

  $resizing = panes[resizing]

  resize = e.pageX - beforeX
  beforeX = e.pageX

  if resizing is "east"
    resize = -resize

  width = getWidth(panes[resizing]) + resize
  
  if width < 0
    width = 0
  
  $resizing.css "width", width

.on "mouseup mouseleave", ->
	resizing = null

resizing = null
beforeX = 0

getTargetPane = (pane="all") ->
  if pane is "all"
    $panes
  else panes[pane]

module.exports = class layout

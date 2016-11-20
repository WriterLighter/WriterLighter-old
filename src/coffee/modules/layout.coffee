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

  width = if $resizing.css "box-sizing" is "border-box"
    do $resizing.innerWidth
  else
    do $resizing.width

  resize = e.pageX - beforeX
  beforeX = e.pageX

  if resizing is "east"
    resize = -resize

  w += resize
  
  if w < 0
    w = 0
  
  $resizing.css "width", w

.on "mouseup mouseleave", ->
	resizing = null

resizing = null
beforeX = 0

getTargetPane = (pane="all") ->
  if pane is "all"
    $panes
  else panes[pane]

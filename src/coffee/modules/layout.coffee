panes =
  east: $ "#pane-east"
  west: $ "#pane-west"

$panes = $ ".pane"

$handles = $ "<div class='pane-resizer'>"
.appendTo ".pane"
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


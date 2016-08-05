layout = $('#container').layout
  south__resizable:      false
  south__spacing_open:   0
  south__spacing_closed: 20
  enableCursorHotkey:   false

window.WriterLighter = window.wl = class WriterLighter

  # WriterLighter modules (alphabetical order).
  @command     = require './js/modules/command'
  @config      = require './js/modules/config'
  @counter     = require './js/modules/counter'
  @editor      = require './js/modules/editor'
  @extension   = require './js/modules/extension'
  @event       = require './js/modules/event'
  @lastedit    = require './js/modules/lastedit'
  @menu        = require './js/modules/menu'
  @ModalWindow = require './js/modules/modalwindow'
  @novel       = require './js/modules/novel'
  @Popup       = require './js/modules/popup'
  @search      = require './js/modules/search'
  @statusBar   = require './js/modules/statusbar'


  @layout      = layout


  # alias
  @on = WriterLighter.event.on

  @startup = ->
    do wl.menu.load
    do wl.extension.load
    if do wl.config.load
      do wl.lastedit.restore

  @quiting = ->
    if do wl.editor.isEdited then do wl.novel.save
    do wl.lastedit.save
    do wl.config.save

do wl.startup

$(window).on "beforeunload", wl.quiting

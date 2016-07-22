window.WriterLighter = window.wl = class WriterLighter
  @command     = require './js/modules/command'
  @config      = require './js/modules/config'
  @counter     = require './js/modules/counter'
  @editor      = require './js/modules/editor'
  @extension   = require './js/modules/extension'
  @lastedit    = require './js/modules/lastedit'
  @menu        = require './js/modules/menu'
  @ModalWindow = require './js/modules/modalwindow'
  @novel       = require './js/modules/novel'
  @Popup       = require './js/modules/popup'
  @search      = require './js/modules/search'
  @statusBar   = require './js/modules/statusbar'

wl.layout = $('#container').layout
  south__resizable:      false
  south__spacing_open:   0
  south__spacing_closed: 20
  enableCursorHotkey:   false


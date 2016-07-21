window.WriterLighter = window.wl = class WriterLighter
  @command     = require './modules/command'
  @config      = require './modules/config'
  @counter     = require './modules/counter'
  @editor      = require './modules/editor'
  @extension   = require './modules/extension'
  @lastedit    = require './modules/lastedit'
  @menu        = require './modules/menu'
  @ModalWindow = require './modules/modalwindow'
  @novel       = require './modules/novel'
  @Popup       = require './modules/popup'
  @search      = require './modules/search'
  @statusBar   = require './modules/statusbar'

wl.layout = $('#container').layout
  south__resizable:      false
  south__spacing_open:   0
  south__spacing_closed: 20
  enableCursorHotkey:   false


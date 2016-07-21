window.WriterLighter = window.wl = class WriterLighter
  @command     = require './app/command'
  @config      = require './app/config'
  @counter     = require './app/counter'
  @editor      = require './app/editor'
  @extension   = require './app/extension'
  @lastedit    = require './app/lastedit'
  @menu        = require './app/menu'
  @ModalWindow = require './app/modalwindow'
  @novel       = require './app/novel'
  @Popup       = require './app/popup'
  @search      = require './app/search'
  @statusBar   = require './app/statusbar'

wl.layout = $('#container').layout
  south__resizable:      false
  south__spacing_open:   0
  south__spacing_closed: 20
  enableCursorHotkey:   false


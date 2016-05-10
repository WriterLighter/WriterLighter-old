# Electron Native
dialog = window.require('remote').dialog
fs = window.require 'fs'
path = window.require 'path'

# Outer Liblary
window.jQuery = window.$ = require 'jquery'
require 'jquery-ui/ui/core'
require 'jquery-ui/ui/widget'
require 'jquery-ui/ui/mouse'
require 'jquery-ui/ui/draggable'
require 'jquery-ui/ui/effect'
require 'jquery.layout'

window.WriterLighter = window.wl = {}

$ ->
  wl.layout = $('#container').layout
    south__resizable:     false
    south__spacing_open:    0
    south__spacing_closed:    20


# Electron or Node.js Native
window.remote = window.require 'remote'
window.dialog = window.require('remote').dialog
window.Menu = remote.require 'menu'
window.fs = window.require 'fs-extra'
window.path = window.require 'path'
window.app = remote.require 'app'
window.browserWindow = remote.require 'browser-window'
window.glob = window.require 'glob'

# Outer Liblary
window.YAML = require "js-yaml"
window.jQuery = window.$ = require 'jquery'
require 'jquery-ui/ui/core'
require 'jquery-ui/ui/widget'
require 'jquery-ui/ui/mouse'
require 'jquery-ui/ui/draggable'
require 'jquery-ui/ui/effect'
require 'jquery-ui/ui/position'
require 'jquery-ui/ui/menu'
require 'jquery-ui/ui/autocomplete'
require 'jquery.layout'

window.WriterLighter = window.wl = {}

$ ->
  wl.layout = $('#container').layout
    south__resizable:     false
    south__spacing_open:    0
    south__spacing_closed:    20


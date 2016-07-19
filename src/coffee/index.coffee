# Electron or Node.js Native
window.require "coffee-script/register"
window.remote = window.require('electron').remote
window.dialog = remote.dialog
window.Menu = remote.Menu
window.fs = window.require 'fs-extra'
window.path = window.require 'path'
window.app = remote.app
window.browserWindow = remote.BrowserWindow
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
    enableCursorHotkey: false


electron = require 'electron'
app = electron.app
browser_window = electron.BrowserWindow
fs = require('fs')
info_path = require('path').join(app.getPath("userData"), "bounds-info.json")
bounds = {}

try
    bounds = JSON.parse(fs.readFileSync(info_path, 'utf8'))
catch e
  bounds.maximize = true

main_window = null
  
app.on 'window-all-closed', ->
  app.quit()

createWindow = () ->
  main_window = new browser_window bounds.bounds
  bounds.maximize and main_window.maximize()
  main_window.loadURL('file://' + __dirname + '/../index.html')
  main_window.on 'closed', ->
    main_window = null
  # main_window.webContents.openDevTools()
  main_window.on 'close', ->
      fs.writeFileSync(info_path, JSON.stringify
        bounds: do main_window.getBounds
        maximize: do main_window.isMaximized
      )

app.on 'ready', createWindow

app.on 'window-all-closed', ->
  if process.platform is 'darwin'
    app.quit

app.on 'activate', ->
  if main_window is null
    createWindow

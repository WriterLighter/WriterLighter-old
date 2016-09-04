electron       = require 'electron'
app            = electron.app
browser_window = electron.BrowserWindow
fs             = require('fs')
userDataPath   = app.getPath "userData"
path           = require "path"
boundsInfoFile = path.join userDataPath, "bounds.json"
configFile     = path.join userDataPath, "config.json"
bounds         = {}

try
    bounds = JSON.parse(fs.readFileSync(boundsInfoFile, 'utf8'))
catch e
  bounds.maximize = true

main_window = null
  
createWindow = () ->
  main_window = new browser_window bounds.bounds
  bounds.maximize and main_window.maximize()
  main_window.loadURL('file://' + __dirname + '/../index.html')
  main_window.on 'closed', ->
    main_window = null
  # main_window.webContents.openDevTools()
  main_window.on 'close', ->
      fs.writeFileSync(boundsInfoFile, JSON.stringify
        bounds: do main_window.getBounds
        maximize: do main_window.isMaximized
      )

  app.on 'window-all-closed', ->
    if process.platform is 'darwin'
      do app.quit

  app.on 'activate', ->
    if main_window is null
      do createWindow

initalStartUp = ->
  setUpWindow = new browser_window width: 800, height: 600
  setUpWindow.loadURL "file://" + path.join __dirname, "..", "welcome.html"
  setUpWindow.on "closed" , ->
    setUpWindow = null

app.on 'ready', ->
  try
    configs = JSON.parse fs.readFileSync(configFile, 'utf8')
    unless Object.keys(configs).length
      throw 'No Configs.'
    do createWindow
  catch e
    do initalStartUp

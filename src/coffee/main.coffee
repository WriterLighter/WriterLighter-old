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

mainWindow = null
  
createWindow = () ->
  try
    JSON.parse fs.readFileSync(configFile, 'utf8')
    mainWindow = new browser_window bounds.bounds
    bounds.maximize and mainWindow.maximize()
    mainWindow.loadURL('file://' + __dirname + '/../index.html')
    mainWindow.on 'closed', ->
      mainWindow = null
    # mainWindow.webContents.openDevTools()
    mainWindow.on 'close', ->
        fs.writeFileSync(boundsInfoFile, JSON.stringify
          bounds: do mainWindow.getBounds
          maximize: do mainWindow.isMaximized
        )

    app.on 'window-all-closed', ->
      if process.platform is 'darwin'
        do app.quit

    app.on 'activate', ->
      if mainWindow is null
        do createWindow
  catch e
    do initalStartUp

initalStartUp = ->
  setUpWindow = new browser_window width: 800, height: 600
  setUpWindow.loadURL "file://" + path.join __dirname, "..", "welcome.html"
  setUpWindow.on "closed" , ->
    setUpWindow = null

app.on 'ready', ->
  do createWindow

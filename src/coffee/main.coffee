electron       = require 'electron'
app            = electron.app
browser_window = electron.BrowserWindow
fs             = require('fs')
userDataPath   = app.getPath "userData"
path           = require "path"
boundsInfoFile = path.join userDataPath, "bounds.yml"
configFile     = path.join userDataPath, "config.yml"
bounds         = {}
ipc            = electron.ipcMain
YAML           = require "js-yaml"

try
  bounds = YAML.load(fs.readFileSync(boundsInfoFile, 'utf8'))
catch e
  bounds.maximize = true

mainWindow = null
setUpWindow = null
  
createWindow = () ->
  try
    YAML.load fs.readFileSync(configFile, 'utf8')
    mainWindow = new browser_window bounds.bounds
    bounds.maximize and mainWindow.maximize()
    mainWindow.loadURL('file://' + __dirname + '/../index.html')
    mainWindow.on 'closed', ->
      mainWindow = null
    # mainWindow.webContents.openDevTools()
    mainWindow.on 'close', ->
        fs.writeFileSync(boundsInfoFile, YAML.dump
          bounds: do mainWindow.getBounds
          maximize: do mainWindow.isMaximized
        )

  catch e
    do initalStartUp

initalStartUp = ->
  setUpWindow = new browser_window width: 800, height: 600
  setUpWindow.loadURL "file://" + path.join __dirname, "..", "welcome.html"
  setUpWindow.on "closed" , ->
    setUpWindow = null

app.on 'ready', ->
  do createWindow
app.on 'window-all-closed', ->
  if process.platform is 'darwin'
    do app.quit
app.on 'activate', ->
  if mainWindow is null or setUpWindow is null
    do createWindow

ipc.on "close-window", (event)->
  do createWindow
  event.sender.send "close-window"

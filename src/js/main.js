const electron       = require('electron');
const { app }            = electron;
const browser_window = electron.BrowserWindow;
const fs             = require('fs');
const userDataPath   = app.getPath("userData");
const path           = require("path");
const boundsInfoFile = path.join(userDataPath, "bounds.yml");
const configFile     = path.join(userDataPath, "config.yml");
let bounds         = {};
const ipc            = electron.ipcMain;
const YAML           = require("js-yaml");

try {
  bounds = YAML.load(fs.readFileSync(boundsInfoFile, 'utf8'));
  if(bounds == null) throw bounds
} catch (e) {
  bounds.maximize = true;
}

let mainWindow = null;
let setUpWindow = null;
  
const createWindow = function() {
  try {
    YAML.load(fs.readFileSync(configFile, 'utf8'));
    mainWindow = new browser_window(bounds.bounds);
    bounds.maximize && mainWindow.maximize();
    mainWindow.loadURL(`file://${__dirname}/../../index.html`);
    mainWindow.on('closed', () => mainWindow = null);
    // mainWindow.webContents.openDevTools()
    return mainWindow.on('close', () =>
        fs.writeFileSync(boundsInfoFile, YAML.dump({
          bounds: mainWindow.getBounds(),
          maximize: mainWindow.isMaximized()
        }))
    );

  } catch (e) {
    return initalStartUp();
  }
};

var initalStartUp = function() {
  setUpWindow = new browser_window({width: 800, height: 600});
  setUpWindow.loadURL(`file://${path.join(__dirname, "..", "..", "welcome.html")}`);
  return setUpWindow.on("closed" , () => setUpWindow = null);
};

app.on('ready', () => createWindow());
app.on('window-all-closed', function() {
  if (process.platform === 'darwin') {
    return app.quit();
  }
});
app.on('activate', function() {
  if (mainWindow === null || setUpWindow === null) {
    return createWindow();
  }
});

ipc.on("close-window", function(event){
  createWindow();
  return event.sender.send("close-window");
});

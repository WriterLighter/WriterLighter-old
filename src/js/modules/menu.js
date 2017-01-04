"use strict"
const YAML     = require("js-yaml");
const electron = require("electron");
const { Menu }     = electron.remote;
const fs       = require('fs');

const appmenu  = {};
const context  = {};
const template = {};
const appmenu  = {};

let _TMP_CONTEXT_MENU_EVENT = null;

module.exports = class menu {
  static buildTemplate(data, type){
    if (type == null) { type = "app"; }
    for (var index = 0; index < data.length; index++) {
      const item = data[index];
      if (item.submenu != null) {
        data[index].submenu = menu.buildTemplate(item.submenu);
      } else if (item.command != null) {
        data[index].click = function(menuItem, browserWindow, event){
          window.__menu = {
            menuItem,
            browserWindow,
            event,
            contextMenuEvent: _TMP_CONTEXT_MENU_EVENT || undefined
          };

          command.execute(data[index].command);

          return window.__menu = undefined;
        };
      }
    }
    return data;
  }

  static load() {
    template = YAML.safeLoad(fs.readFileSync("menu.yml"));
    appmenu = Menu.buildFromTemplate(menu.buildTemplate(template.appmenu));
    return Menu.setApplicationMenu(appmenu);
  }

  static showContextMenu(event) {
    const addtionalMenu = event.target.dataset.context;
    let cmenu = template.context.main.concat();
    if (addtionalMenu != null) {
      addtionalMenu.split(" ").forEach(function(item, index){
        cmenu.push({
          type: "separator"});
        return cmenu = cmenu.concat(template.context[item]);});
    }
    _TMP_CONTEXT_MENU_EVENT = event;
    return Menu.buildFromTemplate(menu.buildTemplate(cmenu)).popup();
  }
}

window.addEventListener("contextmenu", menu.showContextMenu);

var command  = require("./command");

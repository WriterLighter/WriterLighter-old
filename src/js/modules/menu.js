"use strict"
const YAML     = require("js-yaml");
const electron = require("electron");
const { Menu }     = electron.remote;
const fs       = require('fs');

let appmenu  = {};
let template = {};

let _TMP_CONTEXT_MENU_EVENT = null;

let menu;

module.exports = menu = class menu {
  static buildTemplate(data, type){
    if (type == null) { type = "app"; }
    for (let index = 0; index < data.length; index++) {
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

          wl.command.execute(data[index].command);

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

  static marge(baseMenu, margeMenu) {
    baseMenu = [...baseMenu];
    margeMenu = [...margeMenu];

    margeMenu.forEach(menuItem => {
      const index = baseMenu.findIndex(
        ({label}) => label === menuItem.label);

      if(index !== -1) {
        if(Array.isArray(baseMenu[index].submenu)
        && Array.isArray(menuItem.submenu)) {
          baseMenu[index].submenu =
            menu.marge(baseMenu[index].submenu, menuItem.submenu);
        }

        delete menuItem.submenu;

        baseMenu[index] = Object.assign({}, baseMenu[index], menuItem);
      } else {
        baseMenu.push(menuItem);
      }
    });

    return baseMenu;
  }
}

window.addEventListener("contextmenu", menu.showContextMenu);

"use strict"
const electron      = require("electron");
const { remote }        = electron;
const { app }           = remote;

module.exports = {
  quit() {
    return app.quit();
  },
  ["open-novel"]() {
    return wl.novel.openNovel();
  },
  ["open-chapter"]() {
    return wl.novel.openChapter();
  },
  ["command-palette"]() {
    return wl.command.palette();
  },
  ["add-chapter"]() {
    return wl.novel.addChapter();
  },
  ["editmode-default"]() {
    return wl.editor.setMode("default");
  },
  ["editmode-intensive"]() {
    return wl.editor.setMode("intensive");
  },
  ["toggle-editmode"]() {
    return wl.layout.toggleMode();
  },
  ["toggle-devtools"]() {
    return remote.getCurrentWindow().toggleDevTools();
  },
  ["reload-window"]() {
    return remote.getCurrentWindow().reload();
  },
  ["toggle-direction"]() {
    return wl.editor.toggleDirection();
  },
  ["new-novel"]() {
    return wl.novel.newNovel();
  },
  ["new-chapter"]() {
    return wl.novel.newChapter();
  },
  ["rename-chapter"]() {
    return wl.novel.renameChapter();
  },
  ["delete-chapter"]() {
    return wl.deleteChapter();
  },
  save() {
    return wl.novel.save();
  },
  search() {
    return wl.search.search();
  },
  replace(){
    return wl.search.replace();
  },
  ["next-chapter"]() {
    return wl.novel.openChapter("next");
  },
  ["back-chapter"]() {
    return wl.novel.openChapter("back");
  },
  ["inspect-element"]() {
    if ((typeof __menu !== 'undefined' && __menu !== null) && (__menu.contextMenuEvent != null)) {
      return __menu.browserWindow.inspectElement(__menu.contextMenuEvent.x, __menu.contextMenuEvent.y);
    } else {
      return new wl.Popup({messeage: "コンテキストメニューから実行してください。"});
    }
  }
};

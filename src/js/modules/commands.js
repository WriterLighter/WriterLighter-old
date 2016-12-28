const electron      = require("electron");
const { remote }        = electron;
const { app }           = remote;

const Popup = require("./popup");

module.exports = {
  quit() {
    return app.quit();
  },
  open_novel() {
    return wl.novel.openNovel();
  },
  open_chapter() {
    return wl.novel.openChapter();
  },
  command_palette() {
    return wl.command.palette();
  },
  add_chapter() {
    return wl.novel.addChapter();
  },
  editmode_def() {
    return wl.editor.setMode("default");
  },
  editmode_int() {
    return wl.editor.setMode("intensive");
  },
  toggle_editmode() {
    return wl.editor.toggleMode();
  },
  toggle_devtools() {
    return remote.getCurrentWindow().toggleDevTools();
  },
  reload_window() {
    return remote.getCurrentWindow().reload();
  },
  toggle_direction() {
    return wl.editor.toggleDirection();
  },
  new_novel() {
    return wl.novel.newNovel();
  },
  new_chapter() {
    return wl.novel.newChapter();
  },
  rename_chapter() {
    return wl.novel.renameChapter();
  },
  delete_chapter() {
    return wl.deleteChapter();
  },
  save() {
    return wl.novel.save();
  },
  search() {
    return wl.search.search();
  },
  next_chapter() {
    return wl.novel.openChapter("next");
  },
  back_chapter() {
    return wl.novel.openChapter("back");
  },
  inspect_element() {
    if ((typeof __menu !== 'undefined' && __menu !== null) && (__menu.contextMenuEvent != null)) {
      return __menu.browserWindow.inspectElement(__menu.contextMenuEvent.x, __menu.contextMenuEvent.y);
    } else {
      return new Popup({messeage: "コンテキストメニューから実行してください。"});
    }
  }
};

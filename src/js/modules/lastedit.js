"use strict"
const { app }    = require("electron").remote;
const YAML   = require("js-yaml");
const fs     = require("fs");
const path   = require('path');

const lastEditPath= path.join(app.getPath("userData"), "lastedit.yml");

module.exports = class lastEdit {
  static save() {
    const savedata = {
      opened: wl.novel.getOpened(),
      status: {
        direction: wl.editor.getDirection()
      }
    };
    return fs.writeFileSync(lastEditPath, YAML.dump(savedata));
  }

  static restore() {
    return fs.readFile(lastEditPath, function(err, text) {
      if (err == null) {
        const data = YAML.load(text);
        const {name, number} = data.opened;

        wl.novel.openNovel(name || "はじめよう");

        (number != null) && wl.novel.openChapter(number);

        return wl.editor.setDirection(data.status.direction);
      } else { return wl.novel.openNovel("はじめよう"); }
    });
  }
}

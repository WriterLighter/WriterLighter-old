"use strict"
const { app }    = require("electron").remote;
const YAML   = require("js-yaml");
const fs     = require("fs");
const path   = require('path');

const lastEditPath= path.join(app.getPath("userData"), "lastedit.yml");

module.exports = class lastEdit {
  static save() {
    const savedata = {
      opened: novel.getOpened(),
      status: {
        direction: editor.getDirection()
      }
    };
    return fs.writeFileSync(lastEditPath, YAML.dump(savedata));
  }

  static restore() {
    return fs.readFile(lastEditPath, function(err, text) {
      if (err == null) {
        const data = YAML.load(text);
        const {name, number} = data.opened;

        novel.openNovel(name || "はじめよう");

        (number != null) && novel.openChapter(number);

        return editor.setDirection(data.status.direction);
      } else { return novel.openNovel("はじめよう"); }
    });
  }
}

const novel  = require("./novel");
const editor = require("./editor");

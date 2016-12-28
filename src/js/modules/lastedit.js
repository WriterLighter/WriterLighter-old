let lastEditPath;
const { app }    = require("electron").remote;
const YAML   = require("js-yaml");
const fs     = require("fs");
const path   = require('path');

module.exports = lastEditPath = undefined;
class lastEdit {
  static initClass() {
    lastEditPath= path.join(app.getPath("userData"), "lastedit.yml");
  }
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

        if (name != null) {
          novel.openNovel(name);
        } else {
          novel.openNovel("はじめよう");
        }

        (number != null) && novel.openChapter(number);

        return editor.setDirection(data.status.direction);
      } else { return novel.openNovel("はじめよう"); }
    });
  }
}
lastEdit.initClass();

var novel  = require("./novel");
var editor = require("./editor");

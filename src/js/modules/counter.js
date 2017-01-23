"use strict"
module.exports = class counter {
  static get(type){
    const val = wl.editor.getText();
    let res = null;

    switch (type) {
      case "letter":
        res = val.length;
        break;

      case "line":
        res = val.split("\n").length;
        break;

      case "byte":
        res = encodeURIComponent(val)
          .replace(/%../g, "x")
          .length;
        break;
    }

    return res;
  }

  static count() {
    const val = wl.editor.getText();
    const res = 0;

    wl.statusBar.register("letter", val.length + "文字");

    wl.statusBar.register("line", val.split("\n").length + "行");

    const byte =
      encodeURIComponent(val)
        .replace(/%../g, "x")
        .length;

    wl.statusBar.register("byte",
      (byte >= 1024 ? (Math.floor( (byte / 1024) * 100 )/100) + "キロ" : byte) + "バイト");

    return;
  }
};


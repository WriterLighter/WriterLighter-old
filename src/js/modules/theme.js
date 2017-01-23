"use strict"
const fs     = require("fs");
const sass   = require("sass.js");
const path   = require("path");
const accord = require("accord");
const less   = accord.load("less");
const $theme = $("#theme");

module.exports = class theme {
  static set(theme) {
    if (theme == null) { theme = wl.config.get("theme") || "wl-light"; }
    wl.config.set("theme", theme);
    if (wl.extension.get(theme, "path") != null) {
      const themeFile = path.join(wl.extension.get(theme, "path"), wl.extension.get(theme, "main"));
      const { ext } = path.parse(themeFile);
      switch (ext) {
        case "css":
          return fs.readFile(themeFile, function(e, r){
            if (e != null) { throw e; }
            return $theme.html(r);
          });

        case "sass":
          return sass.compileFile(themeFile, r=> $theme.html(r));

        case "scss":
          return sass.compileFile(themeFile, r=> $theme.html(r));

        case "less":
          return less.renderFile(themeFile, r=> $theme.html(r));
      }
    }
  }

  static getList() {
    return wl.extension.getList("theme");
  }

  static get() {
    return wl.config.get("theme");
  }
};


"use strict"
const fs     = require("fs");
const sass   = require("sass.js");
const path   = require("path");
const accord = require("accord");
const less   = accord.load("less");
const $theme = $("#theme");

module.exports = class theme {
  static set(theme) {
    if (theme == null) { theme = config.get("theme") || "wl-light"; }
    config.set("theme", theme);
    if (extension.get(theme, "path") != null) {
      const themeFile = path.join(extension.get(theme, "path"), extension.get(theme, "main"));
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
    return extension.getList("theme");
  }

  static get() {
    return config.get("theme");
  }
};

const config    = require("./config");
const extension = require("./extension");

"use strict"
require('coffee-script').register();
const glob = require('glob');
const path = require('path');
const { app }  = require("electron").remote;
const fs   = require('fs');
const YAML = require('js-yaml');

let extensions = [];

const getExtensionDirList = function() {
    let dir;
  return (dir = wl.config.get("extensionDirectory")) != null ? dir : [
    path.join(".", "extensions"),
    path.join(app.getPath("userData"), "extensions")
  ];
};
const extensionIndex = {};
const themeIndex     = {};
const extensionFile = path.join(app.getPath("userData"), "extensions.yml");

const $tabList = $("#ext-tab");
const $content = $("#ext-content");

const extTabTag = pkgInfo =>
  `<li><input type='radio' name='ext-tabs' \
style='background-image:url(${(pkgInfo.icon != null) ? path.join(pkgInfo.path, pkgInfo.icon) : ""})' \
value='${pkgInfo.name}' ></li>`;

$tabList.on("change", "input", function() {
  return extensions.open(this.value);
});

module.exports = class extension {
  static checkInstall() {
    for (let extDir of Array.from(getExtensionDirList())) {
      for (let packageJSON of Array.from(glob.sync(path.join(extDir, "*", "package.json")))) {
        let packagePath = path.dirname(packageJSON);
        if (!path.isAbsolute(packagePath)) {
          packagePath = path.join(__dirname, "..", "..", "..", packagePath);
        }
        const packageInfo = JSON.parse(fs.readFileSync(packageJSON, "utf-8"));
        if (!extensionIndex[packageInfo.name] && !themeIndex[packageInfo.name]) {
          let imported, index, type;
          const { ext } = path.parse(packageInfo.main);
          if (ext === "js" || ext === "coffee") {
            imported = require(path.join(packagePath, packageInfo.main));
            index = extensionIndex;
            type = "extension";
          } else {
            imported =  fs.readFileSync(path.join(packagePath, packageInfo.main));
            index = themeIndex;
            type = "theme";
          }

          index[packageInfo.name] = extensions.push(Object.assign({},
            packageInfo, {
            path: packagePath,
            imported,
            type
          }
            )
          );
        }
      }
    }
    extension.save();
    return extension.updateExtensionTabs();
  }

  static updateExtensionTabs() {
    let html = "";
    for (let ext of Array.from(extensions)) {
      html += extTabTag(ext);
    }
    return $tabList.html(html);
  }

  static save() {
    return fs.writeFileSync(extensionFile, YAML.safeDump(extensions));
  }

  static load() {
    extension.checkInstall();
    extensions = YAML.load(fs.readFileSync(extensionFile, 'utf8'));
    for (let i = 0; i < extensions.length; i++) {
      const extensionInfo = extensions[i];
      const index = (() => { switch (extensionInfo.type) {
        case "extension":
          return extensionIndex;
        case "theme":
          return themeIndex;
      } })();
      index[extensionInfo.name] = i;
      extensionInfo.imported = require(path.join(extensionInfo.path, extensionInfo.main));
    }
    extension.updateExtensionTabs();
    return wl.theme.set();
  }

  static open(name){
    $(`[name='ext-tabs'][data-name='${name}']`).prop("checked", true);
    const html = fs.readFileSync(path.join(extensions[name].path, extensions[name].view)).toString();
    $("#ext-content").html(html);
    return __guardMethod__(extensions[name], 'onview', o => o.onview());
  }

  static get(name, prop) {
    if (prop == null) { prop = "imported"; }
    return __guard__(extensions[extensionIndex[name] || themeIndex[name]], x => x[prop]);
  }

  static getList(type) {
    if (type == null) { type = "extensions"; }
    switch (type) {
      case "extensions":
        return Object.keys(extensionIndex);
      case "theme":
        return Object.keys(themeIndex);
    }
  }
}

const config = require("./config");
const theme  = require("./theme");

function __guardMethod__(obj, methodName, transform) {
  if (typeof obj !== 'undefined' && obj !== null && typeof obj[methodName] === 'function') {
    return transform(obj, methodName);
  } else {
    return undefined;
  }
}
function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}

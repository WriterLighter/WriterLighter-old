let extensions;
require('coffee-script').register();
const glob = require('glob');
const path = require('path');
const { app }  = require("electron").remote;
const fs   = require('fs');
const YAML = require('js-yaml');

module.exports = extensions = undefined;
let getExtensionDirList = undefined;
let extensionIndex = undefined;
let themeIndex = undefined;
let extensionFile = undefined;
let $tabList = undefined;
let $content = undefined;
let extTabTag = undefined;
class extension {
  static initClass() {
    extensions = [];
    getExtensionDirList = function() {
      let left;
      return (left = config.get("extensionDirectory")) != null ? left : [
        path.join(".", "extensions"),
        path.join(app.getPath("userData"), "extensions")
      ];
    };
    extensionIndex = {};
    themeIndex     = {};
    extensionFile = path.join(app.getPath("userData"), "extensions.yml");
  
    $tabList = $("#ext-tab");
    $content = $("#ext-content");
  
    $tabList.on("change", "input", function() {
      return extensions.open(this.value);
    });
  
    extTabTag = pkgInfo =>
      `<li><input type='radio' name='ext-tabs' \
style='background-image:url(${(pkgInfo.icon != null) ? path.join(pkgInfo.path, pkgInfo.icon) : ""})' \
value='${pkgInfo.name}' ></li>`
    ;
  }


  static checkInstall() {
    for (let extDir of Array.from(getExtensionDirList())) {
      for (let packageJSON of Array.from(glob.sync(path.join(extDir, "*", "package.json")))) {
        let packagePath = path.dirname(packageJSON);
        if (!path.isAbsolute(packagePath)) {
          packagePath = path.join(__dirname, "..", packagePath);
        }
        const packageInfo = JSON.parse(fs.readFileSync(packageJSON, "utf-8"));
        if (!~extensionIndex.indexOf(packageInfo.name) || !~themeIndex.indexOf(packageInfo.name)) {
          var imported, index, type;
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
            path: packageInfoPath,
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
      extension = extensions[i];
      const index = (() => { switch (extension.type) {
        case "extension":
          return extensionIndex;
        case "theme":
          return themeIndex;
      } })();
      index[extension.name] = i;
      extension.imported = require(path.join(extsnsion.path, extension.main));
    }
    extension.updateExtensionTabs();
    return theme.set();
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
extension.initClass();

var config = require("./config");
var theme  = require("./theme");

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
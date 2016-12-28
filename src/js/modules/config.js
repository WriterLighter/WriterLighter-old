let configs;
const path   = require('path');
const { app }    = require('electron').remote;
const { dialog } = require('electron');
const fs     = require('fs');
const YAML   = require("js-yaml");

module.exports = configs = undefined;
let configIndex = undefined;
let configFile = undefined;
class config {
  static initClass() {
    configs = [];
    configIndex = {};
    configFile = path.join(app.getPath("userData"), "config.yml");
  }

  static save() {
    try {
      fs.writeFileSync(configFile, YAML.dump(configs));
      return configs;
    } catch (error) {
      return {};
    }
  }

  static load() {
    configs = YAML.load(fs.readFileSync(configFile, 'utf8'));
    return Array.from(configs).map((cfg, index) =>
      configIndex[cfg.name] = index);
  }

  static get(name, key){
      if (key == null) { key = "value"; }
      return __guard__(configs[configIndex[name]], x => x[key]);
    }
  
  static set(name, value, key) {
    if (key == null) { key = "value"; }
    if (configIndex[name] == null) {
      configIndex[name] = configs.push({});
    }

    if (Object.prototype.toString.call(value) === "[object Object]") {
      configs[configIndex[name]] = value;
    } else {
      configs[configIndex[name]][key] = value;
    }

    return config.save();
  }
}
config.initClass();

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
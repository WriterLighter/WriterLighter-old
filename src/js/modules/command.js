let commands;
const Popup = require("./popup");

module.exports = commands = undefined;
let parse = undefined;
class command {
  static initClass() {
    commands =
      {default: require("./commands")};
  
    parse = function(command) {
      const args = command.split(" ");
      const c = args.shift().split(":");
      return {
        args,
        extension: (c[1] != null) ? c[0] : "default",
        command: c.pop()
      };
    };
  }

  static execute(command){
    const c = parse(command);
    return commands[c.extension][c.command].apply(this, c.args);
  }

  static palette() {
    const palette = new Popup({
      type:"prompt",
      messeage: "コマンドを入力…",
      complete: command.getList()
    });

    return palette.on("hide", command.execute);
  }

  static getList() {
    return Object.keys(commands);
  }

  static marge(margeCommands, extname) {
    if (extname !== "default") {
      return Object.assign(commands[extname], margeCommands);
    }
  }
}
command.initClass();

"use strict"
let commands = {"default": require("./commands")};
const parse = function(command) {
  const args = command.split(" ");
  const c = args.shift().split(":");
  return {
    args,
    extension: (c[1] != null) ? c[0] : "default",
    command: c.pop()
  };
};

module.exports = class command {
  static execute(command){
    const c = parse(command);
    return commands[c.extension][c.command](c.args);
  }

  static palette() {
    const palette = new wl.Popup({
      type:"prompt",
      messeage: "コマンドを入力…",
      complete: command.getList()
    });

    palette.on("hide", command.execute);
  }

  static getList() {
    return Object.keys(commands);
  }

  static marge(margeCommands, extname) {
    if(extname == null){
      throw new TypeError("extname is required argument.");
    }
    Object.assign(commands[extname], margeCommands);
  }
}

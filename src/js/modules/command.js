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

let command;

module.exports = command = class {
  static execute(command){
    const c = parse(command);
    return commands[c.extension][c.command](c.args);
  }

  static palette() {
    new wl.Prompt("input command",
    { completes:wl.command.getList() })
    .on("close", value => command.execute(value));
  }

  static getList() {
    const res = [];
    Object.entries(commands).forEach(([extension, commands]) =>{
      if(extension === "default")
        res.push(...Object.keys(commands));
      res.push(...Object.keys(commands).map(
        command => extension + ":" + command))
    });
    return res;
  }

  static marge(margeCommands, extname) {
    if(extname == null){
      throw new TypeError("extname is required argument.");
    }
    Object.assign(commands[extname], margeCommands);
  }
}

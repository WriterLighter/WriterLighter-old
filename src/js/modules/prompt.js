"use strict"
const EventEmitter2 = require("eventemitter2");

const $prompt = $("#prompt");
const $message = $("#prompt-message");
const $input = $("#prompt-input");
const $error = $("#prompt-error");
const $completeList = $("#prompt-complete-list");

const defaultOptions = {
  open: true
}

let open;

module.exports = class Prompt extends EventEmitter2 {
  constructor(message, options) {
    this.message = message;
    if(options.open !== false) {
      this.open();
    }
  }

  open(){
    if(open != null) throw new Error("Another prompt already opened.");
    $messeage.html(this.message);
    this.emit("update", "");
    $prompt.addClass("open");
    open = this;
  }

  close(){
    if(this !== open) throw new Error("The prompt is not opened");
    if(this.emit("will-close")){
      $input.off();
      $prompt.removeClass("open");
      $prompt.one("transitionend", () => this.emit("hide"));
      open = null;
    }
  }

  getValue(){
    return this === open ? $input.val() : "";
  }

  setValue(value){
    this === open && $input.val(value);
  }

  isOpened(){
    return opened === this;
  }
}

$input.on("input", e => open && open.emit("update"));

$input.on("keydown", e => {
  if(open){
    switch(e.keyCode){
      case 13:
        open.close();
        break;
    }
  }
});

$input.on("blur", e => open && open.close());

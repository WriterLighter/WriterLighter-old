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
  constructor(message, options={}) {
    super();
    this.message = message;
    if(options.open !== false) {
      this.open();
    }
  }

  open(){
    if(open != null) throw new Error("Another prompt already opened.");
    $message.html(this.message);
    this.emit("update", "");
    $prompt.addClass("open");
    open = this;
  }

  close(){
    if(this !== open) throw new Error("The prompt is not opened");
    const value = this.getValue();
    this.emit("will-close", value);
    $prompt.removeClass("open");
    $prompt.one("transitionend", () => this.emit("close", value));
    open = null;
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

  setComplete(completes) {
    const $f = $(document.createDocumentFragment());
    completes.forEach(v =>
      $("<li>")
        .text(typeof v === "string" ? v : v.text)
        .appendTo($f));
    $completeList.empty().append($f);
    this.completes = completes;
    this._focusedComplete = undefined;
  }

  getComplete () {
    return this.completes;
  }

  focusComplete(index) {
    $completeList.children(".opened").removeClass("opened");
    const completes = this.getComplete();
    const length = completes.length;
    index = index % length;
    if (index < 0)
      index = length + index;
    $completeList.children("li").eq(index).addClass("opened");
    this._focusedComplete = index;
    const value = completes[index]
    this.setValue(typeof value === "string" ? value : value.value)
  }

  getFocusedComplete(){
    return this._focusedComplete;
  }
}

$input.on("input", e => open && open.emit("update"));

$input.on("keydown", e => {
  const focused = open.getFocusedComplete();
  if(open){
    switch(e.keyCode){
      case 13:
        open.close();
        break;
      case 38:
        open.focusComplete(isNaN(focused) ? -1 : focused - 1);
        break;
      case 40:
        open.focusComplete(isNaN(focused) ? 0 : focused + 1);
        break;
    }
  }
});

$input.on("blur", e => open && open.close());

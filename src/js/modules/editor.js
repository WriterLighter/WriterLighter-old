"use strict"
const currentWindow = require("electron").remote.getCurrentWindow();

const $input = $("#input-text");
const $wrapper = $("#editor-wrap");
const $highlights = $("#highlights");
const $highlightBase = $("#highlight-base");

let edited = false;
let previousInput = "";
let saveTimeout = null;
let pressedKey = 0;
let beforeCaret = "";

const autoHighlights = {};
const highlightElements = {};

let addedsByEscape = [];
let src = "";
let escapedInput = "";

const updateBeforeCaret = function(e){
  if (!$input.is(document.activeElement)) {
    return;
  }

  const sel = getSelection();

  const range = document.createRange();
  range.setStart($input[0], 0);
  range.setEnd(sel.anchorNode, sel.anchorOffset);

  beforeCaret = range.toString().replace(/\n/g , "");

  let l = 0;
  return (() => {
    const result = [];
    for (let line of Array.from(editor.getText().split("\n"))) {
      l += line.length;
      if (l >= beforeCaret.length) { break; }
      beforeCaret = `${beforeCaret.slice(0,l)}\n${beforeCaret.slice(l)}`;
      result.push(l++);
    }
    return result;
  })();
};

const htmlEscape = function(src) {
  const addeds = [];
  const escape = {
    '&': '&amp;',
    "'": '&#x27;',
    '`': '&#x60;',
    '"': '&quot;',
    '<': '&lt;',
    '>': '&gt;'
  };

  const escapeRegExp = new RegExp(`[${Object.keys(escape).join("")}]`, "g");

  const escaped = src.replace(escapeRegExp, function(m,i) {
    const r = escape[m];
    addeds[i] = r.length - m.length;
    return r;
  });

  return {
    escaped,
    addeds
  };
};

const _onchange = function() {
  updateBeforeCaret();

  src = editor.getText();
  if (src !== previousInput) {
    $highlightBase[0].innerText = src;
    const {addeds, escaped} = htmlEscape(src);
    addedsByEscape = addeds;
    escapedInput = escaped;

    editor.markAutoHighlights();

    if (edited === false) {
      edited = true;
      document.title = `* ${document.title}`;
    }
    (saveTimeout != null) && clearTimeout(saveTimeout);

    if (pressedKey === 13 &&
    src.split("\n").length > previousInput.split("\n").length) {

      const match = beforeCaret.match(/^[ 　\t]+/gm);
      if (match != null) {
        document.execCommand('insertHTML', false, match.pop());
      }
    }

    wl.counter.count();
    previousInput = src;
    return saveTimeout = setTimeout(wl.novel.save
    , !isNaN(wl.config.get("saveTimeout")) ? wl.config.get("saveTimeout") : 3000);
  }
};

const createHighlight = function(match, message) {
  const lines = match
  .input
  .slice(0,  match.index + 1)
  .split("\n");

  const typeOfMessage = Object.prototype.toString.call(message);

  message = typeOfMessage === "[object String]" ?
    message.replace(/\$([$&`']|[0-9]+)/, function(m, $0) {
      if (isNaN($0)) {
        switch ($0) {
          case "$":
            return "$";
          case "&":
            return match[0];
          case "`":
            return match.input.slice(0, match.index);
          case "'":
            return match.input.slice(match.index + match[0].length);
        }
      } else {
        return match[$0] != null ? match[$0] : "";
      }
    })
  : typeOfMessage === "[object Function]" ?
    (match.push(match.index, match.input),
    message.apply(undefined, match))
  :
    undefined;

  return {
    line: lines.length,
    column: lines.pop().length,
    index: match.index + 1,
    message,
    length: match[0].length
  };
};

const getAddedIndex = function(index) {
  --index;

  return index +
  addedsByEscape
  .slice(0, index)
  .reduce(((p,c) => p + c), 0);
};

const editor = module.exports = class {
  static setDirection(direction){
    switch (direction) {
      case "vertical":
        return $wrapper.addClass("vertical");
      case "horizontal":
        return $wrapper.removeClass("vertical");
      default:
        return editor.setDirection("horizontal");
    }
  }

  static getDirection() {
    if ($input.hasClass("vertical")) { return "vertical"; } else { return "horizontal"; }
  }

  static toggleDirection() {
    if (editor.getDirection() === "vertical") {
      return editor.setDirection("horizontal");
    } else {
      return editor.setDirection("vertical");
    }
  }

  static markAutoHighlights(id){
    if (id == null) { id = "all"; }
    const _mark = function(id) {
      let length, match;
      const highlight = autoHighlights[id];
      const indices = [];
      const { rule } = highlight;
      const typeOfRule = ({}).toString.call(rule);
      if (typeOfRule === "[object String]") {
        let index;
        ({ length } = rule);
        let startIndex = 0;
        while ((index = src.indexOf(rule, startIndex)) > -1) {
          match = [rule];
          match.index = index;
          match.input = src;

          indices.push(createHighlight(match, highlight.message));
          startIndex = index + length;
        }
      } else if (typeOfRule === "[object RegExp]") {
        while (((match = rule.exec(src)) != null) && (rule.global || indices.length === 0)) {
          indices.push(createHighlight(match, highlight.message));
        }
      } else {
        return;
      }

      return editor.highlight(id, indices);
    };

    if (id === "all") {
      return (() => {
        const result = [];
        for (id in autoHighlights) {
          result.push(_mark(id));
        }
        return result;
      })();
    } else {
      return _mark(id);
    }
  }

  static setAutoHighlighter(id, changeValue){
    if (id == null) { throw new Error("id is a required argument"); }
    if (autoHighlights[id] == null) {
      autoHighlights[id] = {};
    }

    Object.assign(autoHighlights[id], changeValue);

    return editor.markAutoHighlights(id);
  }

  static getAutoHighlighter(id) {
    if (id == null) { id = "all"; }
    if (id === "all") {
      return autoHighlights;
    } else {
      return autoHighlights[id];
    }
  }

  static highlight(id, posArray) {
    let el;
    let addedEnd, addedStart, end, start;
    let highlightedHTML = escapedInput;
    if (highlightElements[id] != null) {
      el = highlightElements[id];
    } else {
      el = highlightElements[id] =
        document.createElement("pre");
      $highlights.append(el);
    }

    posArray.reverse();

    highlights[id] = Array.from(posArray).map((pos) =>
      (start = pos.index = pos.index ||
        (highlightedHTML.split("\n")
        .slice(0 ,pos.line - 1)
        .join("\n")
        .length + pos.column + 1),

      end = start + (pos.length || 1),

      addedStart = getAddedIndex(start),
      addedEnd = getAddedIndex(end),

      highlightedHTML = `${
          highlightedHTML.slice(0, addedStart)
        }<mark class="hl-${id}">${
          highlightedHTML.slice(addedStart, addedEnd)
        }</mark>${
          highlightedHTML.slice(addedEnd)
        }`,

      pos));

    el.innerHTML = highlightedHTML;

    return highlights[id];
  }

  static getHighlights(id){
    if (id === "all") {
      return highlights;
    } else {
      return highlights[id];
    }
  }

  static getHighlightElement(id){
    if(id == null || id === "all"){
      return  highlightElements;
    } else{
      return highlightElements[id];
    }
  }

  static clearWindowName() {
    const opened = wl.novel.getOpened();
    return document.title = `${opened.chapter.name} - ${opened.novel.name} | WriterLighter`;
  }

  static setText(text) {
    $input[0].innerText = text;
    return _onchange();
  }

  static getText() {
    return $input[0].innerText;
  }

  static isEdited() {
    return edited;
  }

  static getInputElement() {
    return $input[0];
  }
    
  static getBeforeCaret() {
    return beforeCaret;
  }

  static undo() {
    return document.execCommand("undo");
  }

  static redo() {
    return document.execCommand("redo");
  }
}

$input.on("keydown keyup click", updateBeforeCaret);

$input.on("input", _onchange);

$input.on("keydown", e=> pressedKey = e.keyCode);

$input.on("paste", function(e){
  e.preventDefault();

  return document.execCommand("insertHTML", false,
    e.originalEvent.clipboardData.getData("text/plain"));
});

// FIXME
//wl.novel.on("savedChapter", () => edited = false);
//wl.novel.on("openedChapter", () => edited = false);

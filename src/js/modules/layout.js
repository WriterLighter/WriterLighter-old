"use strict"
const currentWindow = require("electron").remote.getCurrentWindow();

const $container = $("#container");
const $footer = $("footer");

const panes = {
  east: $("#pane-east"),
  west: $("#pane-west")
};

const $panes = $(".pane");

const resizers = {};

let resizing = null;
let beforeX = 0;

//layoutMode
//0:標準モード
//1:超集中モード
let layoutMode = 0;

const setResizerPosition = function(pane) {
  const w = panes[pane].innerWidth();
  return resizers[pane].css(pane === "east" ?
    {left: w}
  :
    {right: w}
  );
};

const startResize = function(e){
  beforeX = e.pageX;
  return resizing = $(this).data("direction");
};

for (let dir in panes) {
  const $pane = panes[dir];
  resizers[dir] = $("<div class='pane-resizer'></div>")
  .appendTo($container)
  .on("mousedown", startResize)
  .data("direction", dir);

  setResizerPosition(dir);
}

$container
.on("mousemove", function(e) {
  if (resizing == null) {
    return;
  }

  e.preventDefault();

  let resize = e.pageX - beforeX;
  beforeX = e.pageX;

  if (resizing === "west") {
    resize = -resize;
  }

  return layout.resizePane(resizing, `+=${resize}`, {animate: false});
})

.on("mouseup mouseleave", () => resizing = null);
const getWidth = function($el) {

  if ($el.css("box-sizing") === "border-box") {
    return $el.innerWidth();
  } else {
    return $el.width();
  }
};

const state = {
  west: {
    beforeWidth: getWidth(panes.west),
    show: true
  },
  east: {
    beforeWidth: getWidth(panes.east),
    show: true
  }
};

const getTargetPane = function(pane) {
  if (pane == null) { pane = "all"; }
  if (pane === "all") {
    return $panes;
  } else { return panes[pane]; }
};

module.exports = class layout {
  static resizePane(pane, size, option){
    if (pane == null) { pane = "all"; }
    if (size == null) { size = 0; }
    if (option == null) { option = {}; }
    const fitResizer = function() {
      if (pane !== "west") {
        setResizerPosition("east");
      }
      if (pane !== "east") {
        return setResizerPosition("west");
      }
    };

    option = Object.assign({
      relative: false,
      animate: true,
      duration: 50
    }
    ,option);

    if (option.relative) {
      size = `+=${size}`;
    }

    getTargetPane(pane)
    .animate({width: size}, {
    duration:
      option.animate ?
        option.duration
      :
        0
    , step: option.animate ?
      fitResizer : undefined
    , complete: option.complete
  }
    );

    if (!option.animate) {
      return fitResizer();
    }
  }

  static hidePane(pane) {
    if (pane == null) { pane = "all"; }
    const _hide = function(pane) {
      if (state[pane].show) {
        state[pane].show = false;
        state[pane].width = getWidth(panes[pane]);
        return layout.resizePane(pane, 0, { complete() {
          panes[pane].hide();
          return resizers[pane].hide();
        }
      }
        );
      }
    };

    if (pane === "west" || pane === "east") {
      return _hide(pane);
    } else if (pane === "all") {
      _hide("west");
      return _hide("east");
    } else {
      throw new Error("invalid value");
    }
  }

  static showPane(pane) {
    if (pane == null) { pane = "all"; }
    const _show = function(pane) {
      if (!state[pane].show) {
        state[pane].show = true;
        return layout.resizePane(pane, state[pane].width, { complete() {
          panes[pane].show();
          return resizers[pane].show();
        }
      }
        );
      }
    };

    if (pane === "west" || pane === "east") {
      return _show(pane);
    } else if (pane === "all") {
      _show("west");
      return _show("east");
    } else {
      throw new Error("invalid value");
    }
  }

  static getPaneElement(pane){
    return panes[pane][0];
  }

  static setMode(mode) {
    switch (mode) {
      case "default":
        layout.showPane("all");
        $footer.show();
        currentWindow.setFullScreen(false);
        layoutMode = mode;
        return new Notification("モード:標準");
  
      case "intensive":
        layout.hidePane("all");
        $footer.hide();
        currentWindow.setFullScreen(true);
        layoutMode = mode;
        return new Notification("モード:超集中モード");
    }
  }
  
  static toggleMode() {
    switch (layoutMode) {
      case "default":
          return layout.setMode("intensive");
      case "intensive":
          return layout.setMode("default");
      default:
          return layout.setMode("default");
    }
  }

  static getMode() {
    return layoutMode;
  }
}


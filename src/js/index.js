"use strict"
window.WriterLighter = window.wl = {
  // WriterLighter modules (alphabetical order).
  app:       require('./modules/app'),
  command:   require('./modules/command'),
  config:    require('./modules/config'),
  counter:   require('./modules/counter'),
  editor:    require('./modules/editor'),
  extension: require('./modules/extension'),
  lastedit:  require('./modules/lastedit'),
  layout:    require('./modules/layout'),
  menu:      require('./modules/menu'),
  novel:     require('./modules/novel'),
  Popup:     require('./modules/popup'),
  search:    require('./modules/search'),
  statusBar: require('./modules/statusbar'),
  theme:     require('./modules/theme'),

  startup() {
    wl.config.load();
    wl.menu.load();
    wl.extension.load();
    return wl.lastedit.restore();
  },

  quiting() {
    if (wl.editor.isEdited()) { wl.novel.save(); }
    wl.lastedit.save();
    wl.config.save();
  }
};

wl.startup();

$(window).on("beforeunload", wl.quiting);

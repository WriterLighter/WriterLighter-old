window.WriterLighter = window.wl = class WriterLighter {
  static initClass() {
  
    // WriterLighter modules (alphabetical order).
    this.command     = require('./modules/command');
    this.config      = require('./modules/config');
    this.counter     = require('./modules/counter');
    this.editor      = require('./modules/editor');
    this.extension   = require('./modules/extension');
    this.event       = require('./modules/event');
    this.lastedit    = require('./modules/lastedit');
    this.layout      = require('./modules/layout');
    this.menu        = require('./modules/menu');
    this.novel       = require('./modules/novel');
    this.Popup       = require('./modules/popup');
    this.search      = require('./modules/search');
    this.statusBar   = require('./modules/statusbar');
    this.theme       = require('./modules/theme');
  
    // alias
    this.on = WriterLighter.event.on;
  }

  static startup() {
    wl.config.load();
    wl.menu.load();
    wl.extension.load();
    return wl.lastedit.restore();
  }

  static quiting() {
    if (wl.editor.isEdited()) { wl.novel.save(); }
    wl.lastedit.save();
    wl.config.save();
  }
};
WriterLighter.initClass();

wl.startup();

$(window).on("beforeunload", wl.quiting);

window.WriterLighter = window.wl = class WriterLighter {
  static initClass() {
  
    // WriterLighter modules (alphabetical order).
    this.command     = require('./js/modules/command');
    this.config      = require('./js/modules/config');
    this.counter     = require('./js/modules/counter');
    this.editor      = require('./js/modules/editor');
    this.extension   = require('./js/modules/extension');
    this.event       = require('./js/modules/event');
    this.lastedit    = require('./js/modules/lastedit');
    this.layout      = require('./js/modules/layout');
    this.menu        = require('./js/modules/menu');
    this.novel       = require('./js/modules/novel');
    this.Popup       = require('./js/modules/popup');
    this.search      = require('./js/modules/search');
    this.statusBar   = require('./js/modules/statusbar');
    this.theme       = require('./js/modules/theme');
  
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

"use strict"
const path     = require('path');
const mkdirp   = require('mkdirp');
const glob     = require('glob');
const fs       = require('fs-extra');
const YAML     = require('js-yaml');
const EventEmitter2 = require("eventemitter2");

let opened = {
  novel: {
    path: "",
    name: ""
  },
  chapter: {
    number: 0,
    type: "",
    name: ""
  }
};

let novelIndex   = {};
let originalFile = "";
let chapterList  = {
  body: $("#chapter-list-body"),
  metadata: $("#chapter-list-metadata")
};

for (let type in chapterList) {
  const $el = chapterList[type];
  $el.on("click", "li", function(e){
    return novel.openChapter(this.dataset.chapterNumber, this.dataset.chapterType);
  });
}

const getChapterPath = function(number, type, name) {
  if (type == null) { type = "body"; }
  if (number === "now") {
    ({number, type} = opened.chapter);
  }

  const index = number - 1;

  if (novelIndex[type] == null) {
    throw new Error("Bad chapter type");
  }

  if (novelIndex[type][index] == null) {
    throw new Error("This index chapter is not existed.");
  }
  
  name = name || novelIndex[type][index];

  return path.join(opened.novel.path, type, `${number}_${name}.txt`);
};

let novel;

module.exports = novel = class novel {
  static initClass() {
    this.emitter = new EventEmitter2;
  }

  static getChapterPath() {
    return getChapterPath.apply(this, arguments);
  }

  static getIndex() {
    return novelIndex;
  }

  static openChapter(number, type) {
    if (type == null) { type = "body"; }
    if ((typeof __menu !== 'undefined' && __menu !== null) && (__menu.contextMenuEvent != null)) {
      number = __menu.contextMenuEvent.target.dataset.chapterNumber;
      type   = __menu.contextMenuEvent.target.dataset.chapterType;
    }
    if (wl.editor.isEdited()) { novel.save(); }

    if (number != null) {
      let chapterPath, text;
      switch (number) {
        case "next":
          ({number, type} = opened.chapter);
          number = (number % novelIndex[type].length) + 1;
          break;
        case "back":
          ({number, type} = opened.chapter);
          number = (number - 1) % novelIndex[type].length;
          if (number <= 0) { number = novelIndex[type].length; }
          break;
      }

      try {
        chapterPath = getChapterPath(number, type);
      } catch (e) {
        new wl.Popup({messeage: e});
      }

      try {
        text = fs.readFileSync(chapterPath, 'utf8');
      } catch (e) {
        if (e.code === 'ENOENT') {
          text = "";
        } else {
          throw e;
        }
      }
      $("#chapter .opened").removeClass("opened");
      wl.editor.setText(text);
      originalFile = text;
      opened.chapter = {
        number,
        type,
        name: novelIndex[type][number - 1],
        path: chapterPath
      };
      wl.lastedit.save();
      $(`#chapter [data-chapter-number='${(number)}'][data-chapter-type='${type}']`)
        .addClass("opened");
      novel.emitter.emit("openedChapter");
      wl.editor.clearWindowName();
      return wl.counter.count();
    } else {
      const getChapter = new wl.Popup({
        type: "prompt",
        messeage: ["章番号を入力…", "タイプを入力…"]});
      getChapter.on("hide", value=> novel.openChapter.call(novel, value));
      return getChapter.show();
    }
  }

  static newChapter(name, type, index){
    if (name == null) { name = "名称未設定"; }
    if (type == null) { ({ type } = opened.chapter); }
    if (index == null) { index = novelIndex[type].length + 1; }
    index = novelIndex[type].splice(index, 0, name);
    novel.open(index);
    novel.reloadChapterList();
    novel.saveIndex();
    return wl.lastedit.save();
  }

  static renameChapter(number, type, name) {
    if (number == null) { ({ number } = opened.chapter); }
    if (type == null) { ({ type } = opened.chapter); }
    if ((typeof __menu !== 'undefined' && __menu !== null) && (__menu.contextMenuEvent != null)) {
      number = __menu.contextMenuEvent.target.dataset.chapterNumber;
    }
    if (name) {
      fs.renameSync(getChapterPath("now"), getChapterPath(number, type, name));
      return novelIndex[type][number - 1] = name;
    } else {
      const prompt = new wl.Popup({
        type:"prompt",
        messeage: "新しい章名を入力してください…"
      });

      return prompt.on("hide", name => novel.renameChapter(number, type, name));
    }
  }

  static deleteChapter(number, type) {
    if (number == null) { ({ number } = opened.chapter); }
    if (type == null) { ({ type } = opened.chapter); }
    if ((typeof __menu !== 'undefined' && __menu !== null) && (__menu.contextMenuEvent != null)) {
      number = __menu.contextMenuEvent.target.dataset.chapterNumber;
      type   = __menu.contextMenuEvent.target.dataset.chapterType;
    }
    const index = number - 1;
    const name = novelIndex[type][chapter];
    const confirm = new wl.Popup({
      type: "prompt",
      messeage: `${name}を削除します。確認のため、章名を入力してください…`
    });
    return confirm.on("hide", function(res) {
      if (res === name) {
        fs.unlinkSync(getChapterPath(number, type));
        novelIndex.chapter.splice(number, 1);
        novel.saveIndex();
        novel.reloadChapterList();
        if (chapterNumber === number) {
          return novel.openChapter(1);
        }
      } else {
        return novel.deleteChapter(number, type);
      }
    });
  }

  static save() {
    return fs.writeFile(getChapterPath("now"), wl.editor.getText(), function(e){
      if (e != null) {
        const errp = new wl.Popup({messeage: e});
        return errp.show();
      } else {
        novel.emitter.emit("savedChapter");
        return wl.editor.clearWindowName();
      }
    });
  }

  static reloadChapterList() {
    return (() => {
      const result = [];
      for (let type in chapterList) {
        const $el = chapterList[type];
        let list = "";
        for (let i = 0; i < novelIndex[type].length; i++) {
          const name = novelIndex[type][i];
          list +=  `<li data-chapter-number='${(i + 1)}' \
data-chapter-type='${type}' data-context='chapter_list'>${name}</li>`;
        }
        result.push($el.html(list));
      }
      return result;
    })();
  }

  static openNovel(name) {
    if ((name != null) && name !== "") {
      opened.novel = {
        name,
        path: path.join(wl.config.get("bookshalf"), name)
      };
      novelIndex = YAML.load(fs.readFileSync(path.join(opened.novel.path,"index.yml"),"utf-8"));
      novel.reloadChapterList();
      novel.emitter.emit("openedNovel");
      if (!novelIndex.body.length) {
        return novel.newChapter("名称未設定", "body");
      } else {
        return novel.openChapter(1, "body");
      }
    } else {
      const getNovelName = new wl.Popup({
        type: "prompt",
        messeage: "小説名を入力…",
        complete: novel.getNovelList()
      });
      return getNovelName.on("hide", novel.openNovel);
    }
  }

  static getNovelList() {
      return Array.from(glob.sync(path.join(wl.config.get("bookshalf"),"*","index.yml"))).map((index) =>
        path.basename(path.dirname(index)));
    }

  static getOpened() {
    return opened;
  }

  static saveIndex() {
    return fs.writeFile(path.join(opened.novel.path, "index.yml"), YAML.dump(novelIndex), function(e){
      if (e != null) { return new wl.Popup({messeage: e}); }
    });
  }

  static newNovel(name){
    if (name) {
      const index = {
        name,
        author: wl.config.get("user-name"),
        metadata: ["プロット"],
        chapter: []
      };
      const novelpath = path.join(wl.config.get("bookshalf"), name);

      if (!mkdirp.sync(path.join(novelpath, "body")) &&
          !mkdirp.sync(path.join(novelpath, "metadata"))) {
        fs.writeFileSync(path.join(novelpath, "index.yml"), YAML.dump(index));
        return novel.openNovel(name);
      }
    } else {
      const p = new wl.Popup({
        type: "prompt",
        messeage: "小説名を入力…"
      });
      return p.on("hide", novel.newNovel);
    }
  }

  static on() { return novel.emitter.on.apply(novel.emitter, arguments); }
}

novel.initClass();

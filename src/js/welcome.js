"use strict"
let jQuery;
const $ = jQuery     = require("./js/jquery.min");
const YAML           = require("js-yaml");
const electron       = require('electron');
const { app }            = electron.remote;
const { BrowserWindow }  = electron.remote;
const { dialog }         = electron.remote;
const fs             = require('fs-extra');
const userDataPath   = app.getPath("userData");
const path           = require("path");
const configFile     = path.join(userDataPath, "config.yml");
let currentPage    = -1;
const $scroll        = $("html, body");
const $sections      = $("section");
const $nextButton    = $("[name='next']");
const $backButton    = $("[name='back']");
const $submitButton  = $("[type='submit']");
const $moveButton    = $("#move button");
const vw             = window.innerWidth;
const ipc            = electron.ipcRenderer;
const thisWindow     = BrowserWindow.getFocusedWindow();

const configs = [
  {description: "名前（ペンネーム）", type: "text"},

  {description: "小説のフォルダ", type: "text"},

  {description: "テーマ", type: "select"},

  {description: "文字色" , type: "color"},
  
  {description: "背景色" , type: "color"}
];

const movePage = function(page){
  if ($sections.eq(page)
  .find("input[type='text']")
  .length) {
    $moveButton.prop("disabled", true);
  }
  currentPage = page;
  page++;
  if (1 >= page) {
    $backButton.addClass("hide");
  } else {
    $backButton.removeClass("hide");
  }

  if (page >= 3) {
    $nextButton.addClass("hide");
    $submitButton.removeClass("hide");
  } else {
    $nextButton.removeClass("hide");
    $submitButton.addClass("hide");
  }

  return $scroll.animate(
    {scrollLeft: page * vw},
    400,
    "swing");
};

$("#start-setting").on("click", function() {
  movePage(0);
  return $("#move").css({display: "block"});
});

$nextButton.on("click", () => movePage(currentPage + 1));
$backButton.on("click", () => movePage(currentPage - 1));

$("form section input[type='text']")
  .on("input", function() {
    let noinput = false;
    $(this)
      . closest("section")
      .find("input[type='text']")
      .each(function() {
        noinput = noinput || !this.value;
        return !noinput;
    });

    return $moveButton.prop("disabled", noinput);
});

$("[data-color]")
  .on("click", function() {
    const colors = this
      .dataset
      .color
      .split(" ");

    $("[name='background']")
      .val(colors[0]);

    return $("[name='letter']")
      .val(colors[1]);});

$(".getpath").on("click", function() {
  const $text = $(this)
    .siblings("[type='text']");

  return $text.val(dialog.showOpenDialog({
    properties: ['openDirectory','createDirectory'],
    defaultPath: $text.val()
  })
  );
});

$("form").on("submit", function(e){
  e.preventDefault();
  const iterable = $(this)
  .serializeArray();
  for (let i = 0; i < iterable.length; i++) {
    const config = iterable[i];
    $.extend(configs[i], config);
  }
  fs.writeFileSync(configFile, YAML.dump(configs));
  fs.mkdirsSync(configs[1].value);
  fs.copySync("./はじめよう" , path.join(configs[1].value, "はじめよう"), {filter(s){ return !~s.indexOf("git"); }});
  $scroll.animate(
    {scrollLeft: 5 * vw},
    400,
    "swing");
  return false;
});

$("[name='bookshalf']")
  .val(path.join((app.getPath("documents")), "Novels"));

$("#start")
  .on("click", function() {
    ipc.send("close-window");
    return ipc.on("close-window", () => thisWindow.close());
});

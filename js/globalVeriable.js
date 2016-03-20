/*
 * グローバル変数定義ファイル
 * コメントは必ず書くこと!
 */

var writerlighter = writerlighter || {};

/*
 * 外部ライブラリ等
 */

// ファイルシステム
var fs = require('fs');

// リモート
var remote = require('remote');

// ダイアログ
var dialog = remote.require('dialog');

// ウィンドウの操作
var browserWindow = remote.require('browser-window');


// メニュー系
var Menu = remote.require('menu');
var MenuItem = remote.require('menu-item');


/*
 * 文字関係
 */
// 一行あたりの最高文字数
writerlighter.maxLetter = 36;

// 一ページあたりの最高字数
writerlighter.maxLine = 46;

// 見かけ上の行
writerlighter.apparentLine = 1;

// ページ数
writerlighter.page = 1;

// 文字数
writerlighter.letter = 0;

// 文字バイト数
writerlighter.byte = 0;

// 実際の行数
writerlighter.line = 1;

// 入力された文字
writerlighter.value = "";

// valueのhtml
writerlighter.valuehtml = "";

// 元のファイル
writerlighter.formerFile = "";

// 変更されたかどうか(boolean)
writerlighter.Edited = false;


/*
 * 要素
 */
// 入力する場所
writerlighter.inputArea = null;
writerlighter.inputTxt = null;

// webview要素
writerlighter.webview;

// 拡張機能のタブ
writerlighter.ext_tabs = document.getElementsByName("tab");

// 開かれたタブのID
writerlighter.openedExt = "home";

// 読み込みが終わったら設定
$(function () {
    writerlighter.inputTxt = document.getElementById("input_txt");
    writerlighter.inputArea = writerlighter.inputTxt;
    writerlighter.webview = document.getElementById('mainWebview');
});

//  0:通常モード
//  1:超集中モード
//  2:カンヅメモード
writerlighter.EditorMode = 0;

//カンヅメモード時パスワード
writerlighter.IntensivePasswd = "";



/*
 * ファイルシステム関係
 */

// ディレクトリのフルパス
writerlighter.dirPath = "";

// ファイルのフルパス
writerlighter.filePath = "";

// 小説名
writerlighter.novelName = "";

// 章名
writerlighter.chapterName = "";

// いろんなデータ
writerlighter.novelInfo = "";

// 設定ファイルディレクトリ
writerlighter.confDir = remote.require("electron").app.getPath('userData');


// index.json
writerlighter.index = {};

// 登場人物リスト
writerlighter.charaList = {};

// 拡張機能に送る変数を入れた連想配列
writerlighter.sendVar = {};

// 拡張機能に送るInterval
writerlighter.sendParamInterval;

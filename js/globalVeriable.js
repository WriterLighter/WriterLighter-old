/*
 * グローバル変数定義ファイル
 * コメントは必ず書くこと!
 */

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
var maxLetter = 36;

// 一ページあたりの最高字数
var maxLine = 46;

// 見かけ上の行
var apparentLine = 1;

// ページ数
var page = 1;

// 文字数
var letter = 0;

// 文字バイト数
var byte = 0;

// 実際の行数
var line = 1;

// 入力された文字
var value = "";

// 元のファイル
var formerFile = "";

// 変更されたかどうか(boolean)
var Edited = false;


/*
 * 要素
 */
// 入力する場所
var inputArea = null;
var inputTxt = null;

// webview要素
var webview;

// 拡張機能のタブ
var ext_tabs = document.getElementsByName("tab");

// 開かれたタブのID
var openedExt = "home";

// 読み込みが終わったら設定
$(function () {
    inputTxt = document.getElementById("input_txt");
    inputArea = inputTxt;
    webview = document.getElementById('mainWebview');
});

//  0:通常モード
//  1:超集中モード
//  2:カンヅメモード
var EditorMode = 0;

//カンヅメモード時パスワード
var IntensivePasswd = "";



/*
 * ファイルシステム関係
 */

// ディレクトリのフルパス
var dirPath = "";

// ファイルのフルパス
var filePath = "";

// 小説名
var novelName = "";

// 章名
var chapterName = "";

// いろんなデータ
var novelInfo = "";

// 設定ファイルディレクトリ
var confDir = remote.require("electron").app.getPath('userData');


// index.json
var index = {};

// 登場人物リスト
var charaList = {};

// 拡張機能に送る変数を入れた連想配列
var sendVar = {};

// 拡張機能に送るInterval
var sendParamInterval;

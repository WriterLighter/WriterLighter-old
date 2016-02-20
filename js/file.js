var fs = require('fs');
var remote = require('remote');
var dialog = remote.require('dialog');
var browserWindow = remote.require('browser-window');

var inputArea = null;
var inputTxt = null;
var footerArea = null;

var currentPath = "";

function FileName(filename) {
    var value = inputTxt.innerText;
    var NoC = value.length;
    var BoC = encodeURI(value).replace(/%[0-9A-F]{2}/g, '*').length;
    var line = value.split("\n").length;

    $("#wc").html(NoC + "文字");
    $("#byte").html(BoC + "バイト");
    $("#line").html(line + "行");

    document.title = currentPath + " - WriterLighter";
}

/**
 * Webページ読み込み時の処理
 */
$(function () {
    // 入力領域
    inputTxt = document.getElementById("input_txt");
    inputArea = inputTxt;
    // フッター領域
    footerArea = document.getElementById("path");

    // ドラッグ&ドロップ関連処理
    // documentにドラッグされた場合 / ドロップされた場合
    document.ondragover = document.ondrop = function (e) {
        e.preventDefault(); // イベントの伝搬を止めて、アプリケーションのHTMLとファイルが差し替わらないようにする
        return false;
    };

    inputArea.ondragover = function () {
        return false;
    };
    inputArea.ondragleave = inputArea.ondragend = function () {
        return false;
    };
    inputArea.ondrop = function (e) {
        e.preventDefault();
        var file = e.dataTransfer.files[0];
        readFile(file.path);
        return false;
    };

});

/**
 * 読み込みするためのファイルを開く
 */
function openLoadFile() {
    var win = browserWindow.getFocusedWindow();

    dialog.showOpenDialog(
        win,
        // どんなダイアログを出すかを指定するプロパティ
        {
            properties: ['openFile'],
            filters: [
                {
                    name: 'Documents',
                    extensions: ['txt', 'text', 'html', 'js']
                 }
             ]
        },
        // [ファイル選択]ダイアログが閉じられた後のコールバック関数
        function (filenames) {
            if (filenames) {
                readFile(filenames[0]);
            }
        });
}

/**
 * テキストを読み込み、テキストを入力エリアに設定する
 */
function readFile(path) {
    currentPath = path;
    fs.readFile(path, function (error, text) {
        if (error != null) {
            alert('error : ' + error);
            return;
        }
        // フッター部分に読み込み先のパスを設定する
        footerArea.innerHTML = path;
        $("title").innerText = path + " - NovelEditor";
        // テキスト入力エリアに設定する
        //console.log(text.toString());
        // TODO
        inputTxt.innerText = (text.toString());
        FileName();
    });
}


/**
 * ファイルを保存する
 */
function saveFile() {
    $(".menubutton.save").addClass("semitransparent");

    //　初期の入力エリアに設定されたテキストを保存しようとしたときは新規ファイルを作成する
    if (currentPath == "") {
        saveNewFile();
        return;
    }

    var win = browserWindow.getFocusedWindow();
    /*
            dialog.showMessageBox(win, {
                    title: 'ファイルの上書き保存を行います。',
                    type: 'info',
                    buttons: ['OK', 'Cancel'],
                    detail: '本当に保存しますか？'
                },
                // メッセージボックスが閉じられた後のコールバック関数
                function (respnse) {
                    // OKボタン(ボタン配列の0番目がOK)
                    if (respnse == 0) {
                        var data = inputTxt.innerText;
                        writeFile(currentPath, data);
                    }
                }
            );
            */
    var data = inputTxt.innerText;
    writeFile(currentPath, data);
    $(".menubutton.save").removeClass("semitransparent");
}

/**
 * ファイルを書き込む
 */
function writeFile(path, data) {
    fs.writeFile(path, data, function (error) {
        if (error !== null) {
            alert('error : ' + error);
            return;
        }
    });
}

/**
 * 新規ファイルを保存する
 */
function saveNewFile() {

    var win = browserWindow.getFocusedWindow();
    dialog.showSaveDialog(
        win,
        // どんなダイアログを出すかを指定するプロパティ
        {
            properties: ['openFile'],
            filters: [
                {
                    name: 'Documents',
                    extensions: ['txt', 'text', 'html', 'js']
                }
            ]
        },
        // セーブ用ダイアログが閉じられた後のコールバック関数
        function (fileName) {
            if (fileName) {
                var data = inputTxt.val();
                currentPath = fileName;
                writeFile(currentPath, data);
                footerArea.innerHTML = currentPath;
                $("title").innerText = fileName + " - NovelEditor";
            }
        }
    );
}

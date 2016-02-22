var fs = require('fs');
var remote = require('remote');
var dialog = remote.require('dialog');
var browserWindow = remote.require('browser-window');

var inputArea = null;
var inputTxt = null;

var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";

/**
 * フルパスからファイル名を取得
 */
function getFileName(fullpath){
    var i = fullpath.split("/").length -1;
    return fullpath.split("/")[i];
}

/**
 * フルパスから小説名を取得
 */
function setNovelName(fullpath){
    var i = fullpath.split("/").length -2;
    novelName = fullpath.split("/")[i];
    setWindowName();
}

/*
 * フルパスから章名を取得
*/
function setChapterName(fullpath){
    setNovelName(fullpath);
    var filename = getFileName(fullpath);
    var arry = filename.split(".");
    arry.pop();
    chapterName = arry.join(".");
    setWindowName();
}


/*
 * ウィンドウ名セット
 */
function setWindowName(){
    if(novelName == ""){
        document.title = "WriterLighter";
    } else {
        if(chapterName == ""){
            document.title = novelName + " - WriterLighter";
        } else {
            document.title = chapterName + " (" + novelName + ") - WriterLighter";
        }
    }
}

/**
 * Webページ読み込み時の処理
 */
$(function () {
    // 入力領域
    inputTxt = document.getElementById("input_txt");
    inputArea = inputTxt;

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
            properties: ['openDirectory']
        },
        // [ファイル選択]ダイアログが閉じられた後のコールバック関数
        function (directory) {
            if (directory) {
                readDir(directory[0]);
            }
        });
}

/**
 * ディレクトリを読み込む関数
 */
function readDir(path) {
    dirPath = path;
    setNovelName(path);
    webview.send("openNovel",path);
}

/**
 * テキストを読み込み、テキストを入力エリアに設定する
 */
function readFile(path) {
    filePath = path;
    fs.readFile(path, function (error, text) {
        if (error != null) {
            alert('error : ' + error);
            return ;
        }
        setChapterName(path);
        // テキスト入力エリアに設定する
        inputTxt.txt(text.toString());
    });
}


/**
 * ファイルを保存する
 */
function saveFile() {
    $(".menubutton.save").addClass("semitransparent");

    //　初期の入力エリアに設定されたテキストを保存しようとしたときは新規ファイルを作成する
    if (filePath == "") {
        saveNewFile();
        return;
    }
/*
    var win = browserWindow.getFocusedWindow();

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
    writeFile(filePath, data);
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
                    extensions: ['txt', 'text']
                }
            ]
        },
        // セーブ用ダイアログが閉じられた後のコールバック関数
        function (fileName) {
            if (fileName) {
                var data = inputTxt.val();
                filePath = fileName;
                writeFile(filePath, data);
            }
        }
    );
}

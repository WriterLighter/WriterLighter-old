
/*
 * ウィンドウ名セット
 */
function setWindowName(){
    if(writerlighter.novelName === ""){
        document.title = "WriterLighter";
    } else {
        if(writerlighter.chapterName === ""){
            document.title = writerlighter.novelName + " - WriterLighter";
        } else {
            document.title = writerlighter.chapterName + " (" + writerlighter.novelName + ") - WriterLighter";
        }
    }
}

/**
 * index情報を読み込み
 */

function getIndex(path){
    writerlighter.index = validateJSON(fs.readFileSync(path + '/index.json', 'utf8'));
    writerlighter.novelInfo = {
        "path" : path,
        "index" : writerlighter.index
    };

    writerlighter.dirPath = path;
    writerlighter.novelName = writerlighter.index.name;
}

/**
 * 登場人物情報を読み込み
 */

function getCharacter(path){
    writerlighter.charaList = validateJSON(fs.readFileSync(path + '/登場人物.json', 'utf8'));
}

/**
 * Webページ読み込み時の処理
 */
$(function () {

    // ドラッグ&ドロップ関連処理
    // documentにドラッグされた場合 / ドロップされた場合
    document.ondragover = document.ondrop = function (e) {
        e.preventDefault(); // イベントの伝搬を止めて、アプリケーションのHTMLとファイルが差し替わらないようにする
        return false;
    };

    writerlighter.inputArea.ondragover = function () {
        return false;
    };
    writerlighter.inputArea.ondragleave = writerlighter.inputArea.ondragend = function () {
        return false;
    };
    writerlighter.inputArea.ondrop = function (e) {
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
    console.log(path);
    writerlighter.dirPath = path;
    getIndex(path);
    getCharacter(path);
    setWindowName();
}

/**
 * テキストを読み込み、テキストを入力エリアに設定する
 */
function readFile(path) {
    writerlighter.filePath = path;
    fs.readFile(path, function (error, text) {
        if (error !== null) {
            alert('error : ' + error);
            return ;
        }
        // テキスト入力エリアに設定する
        writerlighter.inputTxt.innerText = text.toString();
        writerlighter.formerFile = text.toString();
        writerlighter.value = text.toString();
        setWindowName();
        writerlighter.Edited = false;
    });

}


/**
 * ファイルを保存する
 */
function saveFile() {
    $(".menubutton.save").addClass("semitransparent");
    $("#status").html(writerlighter.filePath + "を保存しています…。");

    //　初期の入力エリアに設定されたテキストを保存しようとしたときは新規ファイルを作成する
    if (writerlighter.filePath === "") {
        saveNewFile();
        return;
    }
    var data = writerlighter.inputTxt.innerText;
    writeFile(writerlighter.filePath, data);
    $(".menubutton.save").removeClass("semitransparent");
    statusMsg(writerlighter.filePath + "を保存しました。",1000);
    setWindowName();
}

/**
 * ファイルを書き込む
 */
function writeFile(path, data) {
    fs.writeFile(path, data, function (error) {
        if (error !== null) {
            alert('error : ' + error);
            return;
            setWindowName();
            writerlighter.Edited = false;
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
                var data = writerlighter.inputTxt.innerText;
                writerlighter.filePath = fileName;
                writeFile(writerlighter.filePath, data);
            }
        }
    );
}

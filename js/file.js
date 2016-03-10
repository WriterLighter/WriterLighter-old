
/*
 * ウィンドウ名セット
 */
function setWindowName(){
    if(novelName === ""){
        document.title = "WriterLighter";
    } else {
        if(chapterName === ""){
            document.title = novelName + " - WriterLighter";
        } else {
            document.title = chapterName + " (" + novelName + ") - WriterLighter";
        }
    }
}

/**
 * index情報を読み込み
 */

function getIndex(path){
    index = validateJSON(fs.readFileSync(path + '/index.json', 'utf8'));
    novelInfo = {
        "path" : path,
        "index" : index
    };

    dirPath = path;
    novelName = index.name;
}

/**
 * 登場人物情報を読み込み
 */

function getCharacter(path){
    charaList = validateJSON(fs.readFileSync(path + '/登場人物.json', 'utf8'));
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
    console.log(path);
    dirPath = path;
    getIndex(path);
    getCharacter(path);
    setWindowName();
}

/**
 * テキストを読み込み、テキストを入力エリアに設定する
 */
function readFile(path) {
    filePath = path;
    fs.readFile(path, function (error, text) {
        if (error !== null) {
            alert('error : ' + error);
            return ;
        }
        // テキスト入力エリアに設定する
        inputTxt.innerText = text.toString();
        formerFile = text.toString();
        setWindowName();
        Edited = false;
    });

}


/**
 * ファイルを保存する
 */
function saveFile() {
    $(".menubutton.save").addClass("semitransparent");
    $("#status").html(filePath + "を保存しています…。");

    //　初期の入力エリアに設定されたテキストを保存しようとしたときは新規ファイルを作成する
    if (filePath === "") {
        saveNewFile();
        return;
    }
    var data = inputTxt.innerText;
    writeFile(filePath, data);
    $(".menubutton.save").removeClass("semitransparent");
    statusMsg(filePath + "を保存しました。",1000);
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
            Edited = false;
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
                var data = inputTxt.innerText;
                filePath = fileName;
                writeFile(filePath, data);
            }
        }
    );
}

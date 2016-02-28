var ipc = require("electron").ipcRenderer;
var fs = require('fs');
var $ = require('./../../js/jquery-1.12.0.min.js');

var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";
var novelInfo = "";

console.log(dirPath);
ipc.on('novelInfo', function (event, novelinfo) { // 小説の情報を取得
    if (novelinfo !== "" && novelinfo.toString() != novelInfo.toString() ) {
            // ▲小説情報が空じゃない且つ小説情報が変更されている

        novelInfo = novelinfo; // グローバル変数に代入
        for (var i = 0; i < novelinfo.index.chapter.length; i++) {
            $("#cahpter-list").append("<li class=\"chapter\"><a onclick=\"sendFileName('"
                                      + novelinfo.index.chapter[i] + "')\">"
                                      + novelinfo.index.chapter[i] +
                                      "</a></li>");
                // <li>タグにして追加
        }
    }
});

function sendFileName(chapter){
    console.log(chapter);
    ipc.sendSync("chapterName",chapter);
}

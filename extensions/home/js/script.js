var ipc = require("electron").ipcRenderer;
var $ = require('./../../js/jquery-1.12.0.min.js');



function sendFileName(chapter){
    console.log(chapter);
    ipc.sendToHost("OpenChapter",chapter);
}


var writerlighter = {};

ipc.sendToHost("getVariable", ["novelInfo"]);

ipc.on("RequestedVariable", function (event, res) { // キャラ設定を取得

    $.extend(writerlighter, res);
        for (var i = 0; i < writerlighter.novelInfo.index.chapter.length; i++) {
            $("#cahpter-list").append("<li class=\"chapter\"><a onclick=\"sendFileName('"
                                      + writerlighter.novelInfo.index.chapter[i] + "')\">"
                                      + writerlighter.novelInfo.index.chapter[i] +
                                      "</a></li>");


    }
});

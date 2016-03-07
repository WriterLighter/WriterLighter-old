var ipc = require("electron").ipcRenderer;
var $ = require('./../../js/jquery-1.12.0.min.js');

var charaList = [] ;

ipc.on('charaList', function (event, charalist) { // キャラ設定を取得
    if (charalist !== "" && charalist.toString() != charaList.toString() ) {
            // ▲情報が空じゃない且つキャラ設定が変更されている

        charaList = charalist; // グローバル変数に代入
        for (var i = 0; i < charalist.length; i++) {
            var name = [];
            for (var ii = 0; ii < charalist[i].name.length; ii++){
                name.push(charalist[i].name[ii]);

            }
            $("#chara-list").append("<li class=\"chapter\"><a src='profile.html?id=" + i +  "'>" +
                                    "<h3>" + name.join("")  +  "<h3>"
                                      + "</a></li>\n");
                // <li>タグにして追加
        }
    }
});

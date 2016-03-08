var ipc = require("electron").ipcRenderer;
var $ = require('./../../js/jquery-1.12.0.min.js');

var getUrlVars = function () {
    var vars = {};
    var param = location.search.substring(1).split('&');
    for (var i = 0; i < param.length; i++) {
        var keySearch = param[i].search(/=/);
        var key = '';
        if (keySearch != -1) key = param[i].slice(0, keySearch);
        var val = param[i].slice(param[i].indexOf('=', 0) + 1);
        if (key != '') vars[key] = decodeURI(val);
    }
    return vars;
}

$(window).load(function () {
    id = parseInt(getUrlVars().id);
})

var id;
var charaList = [];

ipc.on('charaList', function (event, charalist) { // キャラ設定を取得
    if (charalist !== "" && JSON.stringify(charalist) != JSON.stringify(charaList)) {
        // ▲情報が空じゃない且つキャラ設定が変更されている

        charaList = charalist; // グローバル変数に代入

        if (current == "profile") {
            showProfile(id);
        } else {
            for (var i = 0; i < charalist.length; i++) {
                var name = [];
                for (var ii = 0; ii < charalist[i].name.length; ii++) {
                    name.push(charalist[i].name[ii]);

                }
                $("#chara-list").append("<li class=\"chapter\"><a href='profile.html?id=" + i + "'>" +
                    "<h3>" + name.join("") + "<h3>" + "</a></li>\n");
                // <li>タグにして追加
            }
        }
    }
});

function showProfile(id) {
    var person = charaList[id];
    var fullname = person.name;
    var pronunciation = person.pronunciation;

    $("[name=\"lastname\"]").val(fullname[0]);
    $("[name=\"firstname\"]").val(fullname[1]);
    $("[name=\"middlename\"]").val(fullname[2]);
    $("[name=\"pron-lastname\"]").val(pronunciation[0]);
    $("[name=\"pron-firstname\"]").val(pronunciation[1]);
    $("[name=\"pron-middlename\"]").val(pronunciation[2]);
    $("[name=\"personality\"]").val(person.personality);
    $("[name=\"age\"]").val(person.age);
}

function saveProfile(id) {
    var person = charaList[id];
    var fullname = person.name;
    var pronunciation = person.pronunciation;

    fullname[0] = $("[name=\"lastname\"]").val();
    fullname[1] = $("[name=\"firstname\"]").val();
    fullname[2] = $("[name=\"middlename\"]").val();
    pronunciation[0] = $("[name=\"pron-lastname\"]").val();
    pronunciation[1] = $("[name=\"pron-firstname\"]").val();
    pronunciation[2] = $("[name=\"pron-middlename\"]").val();
    person.personality = $("[name=\"personality\"]").val();
    person.age = $("[name=\"age\"]").val(person.age);
    ipc.sendToHost("saveCharacter", charaList);
    console.log(charaList);
}

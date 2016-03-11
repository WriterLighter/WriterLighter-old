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
};

$(function () {
    id = parseInt(getUrlVars().id);
});

var id;
var writerlighter = {};

ipc.sendToHost("getVariable", ["charaList"]);

ipc.on("RequestedVariable", function (event, res) { // キャラ設定を取得

    //writerlighter.charaList = res.charaList; // グローバル変数に代入
    $.extend(writerlighter, res);


    switch (current) {
    case "profile":
        showProfile();
        break;

    case "index":
        for (var i = 0; i < writerlighter.charaList.length; i++) {
            var name = [];
            for (var ii = 0; ii < writerlighter.charaList[i].name.length; ii++) {
                name.push(writerlighter.charaList[i].name[ii]);

            }
            $("#chara-list").append("<li class=\"chapter\"><a href='profile.html?id=" + i + "'>" +
                "<h3>" + name.join("") + "<h3>" + "</a></li>\n");
            // <li>タグにして追加
        }
        break;

    }
});

function showProfile() {
    var person = writerlighter.charaList[id];
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

    for (var key in writerlighter.charaList[id].detail) {
        console.log(key + " : " + writerlighter.charaList[id].detail[key]);
        $("#detail").append("<li><label>" + key +
                            "<input type=\"text\" name=\"" + key + "\" value=\""
                            + writerlighter.charaList[id].detail[key] + "\">"
                            +  "</label></li>");
    }
}

function saveProfile() {
    var person = writerlighter.charaList[id];
    var fullname = person.name;
    var pronunciation = person.pronunciation;

    fullname[0] = $("[name=\"lastname\"]").val();
    fullname[1] = $("[name=\"firstname\"]").val();
    fullname[2] = $("[name=\"middlename\"]").val();
    pronunciation[0] = $("[name=\"pron-lastname\"]").val();
    pronunciation[1] = $("[name=\"pron-firstname\"]").val();
    pronunciation[2] = $("[name=\"pron-middlename\"]").val();
    person.personality = $("[name=\"personality\"]").val();
    person.age = $("[name=\"age\"]").val();

    for (var key in writerlighter.charaList[id].detail) {
        person.detail[key] = $("[name=\"" + key + "\"]").val();
    }

    ipc.sendToHost("saveCharacter", writerlighter.charaList);
    console.log(writerlighter.charaList);
}

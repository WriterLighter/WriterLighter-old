var maxLetter = 36;
var maxLine = 46;
var apparentLine = 1;
var page = 1;
var letter = 0;
var byte = 0;
var line = 1;
var value = "";

function count() {

    value = inputTxt.innerText;

    letter = value.length;
    byte = encodeURI(value).replace(/%[0-9A-F]{2}/g, '*').length;
    line = value.split("\n").length;
    for (var i = 0; i < line; i++) {
        apparentLine = apparentLine + Math.ceil((value.split("\n")[i].length) / maxLetter);
    }
    apparentLine = --apparentLine;
    page = Math.ceil( apparentLine / maxLine );

    $("#wc").html(letter + "文字");
    $("#line").html(line + "行");
    if (byte >= 1024) {
        $("#byte").html(((Math.floor(byte / 1024 * 10)) / 10) + "キロバイト");
    } else {
        $("#byte").html(byte + "バイト");
    }
}

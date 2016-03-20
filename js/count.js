function count() {
    var value = writerlighter.inputTxt.innerText;
    writerlighter.letter = value.length;
    writerlighter.byte = encodeURI(value).replace(/%[0-9A-F]{2}/g, '*').length;
    writerlighter.line = value.split("\n").length;
    for (var i = 0; i < writerlighter.line; i++) {
        writerlighter.apparentLine = writerlighter.apparentLine + Math.ceil((value.split("\n")[i].length) / writerlighter.maxLetter);
    }
    writerlighter.apparentLine = --writerlighter.apparentLine;
    writerlighter.page = Math.ceil( writerlighter.apparentLine / writerlighter.maxLine );

    $("#wc").html(writerlighter.letter + "文字");
    $("#line").html(writerlighter.line + "行");
    if (writerlighter.byte >= 1024) {
        $("#byte").html(((Math.floor(writerlighter.byte / 1024 * 10)) / 10) + "キロバイト");
    } else {
        $("#byte").html(writerlighter.byte + "バイト");
    }
}

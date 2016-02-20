function count() {

    var txtvalue = $("#input_txt").text();

    var NoC = txtvalue.length;
    var BoC = encodeURI(txtvalue).replace(/%[0-9A-F]{2}/g, '*').length;
    var line = $("#input_txt").html().split("<br>").length　 - 1;
    line = line + ($("#input_txt").html().split("<div>").length - 1);
    line = line - ($("#input_txt").html().split("<div><br></div>").length - 1);
    line = ++line;

    $("#wc").html(NoC + "文字");
    $("#line").html(line + "行");
    if (BoC >= 1024) {
        $("#byte").html(Math.floor(BoC / 1024) + "キロバイト");
    } else {
        $("#byte").html(BoC + "バイト");
    }
}

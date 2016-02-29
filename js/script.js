$(function (){

    // 何か入力された時のイベント


    $("#input_txt").keyup(function () {
        count();


    });

    $('div.split-pane').splitPane();




});

var csObj = new Object();
csObj.theme = "dark";

$(window).load(function () {
    $("#container").mCustomScrollbar(csObj);
});

function toggleWritingMode() {
    console.log(document.getElementById("writingMode").checked);
    if (document.getElementById("writingMode").checked) {
        $("#input_txt").addClass("write-vertical");
    } else {
        $("#input_txt").removeClass("write-vertical");
    }
}

function toggleWebviewDevTools() {
    var webview = $("#mainWebview");
    if (webview.isDevToolsOpened()) {
        webview.closeDevTools();
    } else {
        webview.openDevTools();
    }
}

var EditorMode = 0;
//EditorMode
//  0:通常モード
//  1:超集中モード
//  2:カンヅメモード

function IntensiveMode() {
    $("#right-component").toggle();
    $("#my-divider").toggle();
    $("header").toggle();
    $("footer").toggle();
    if (EditorMode == 0) {
        $("#left-component").css("right", "0px")
                            .css("margin","0px");
        $("#container").css("padding", "0");
        EditorMode = 1;
        browserWindow.getFocusedWindow().setFullScreen(true);
        $.amaran({
            "message": "超集中モード起動\n解除はF11キー"
        });
    } else {
        $("#left-component").css("right", "260px")
                            .css("margin-right","5px");
        $("#container").css("padding", "25px 0 25px 0");
        EditorMode = 0;
        browserWindow.getFocusedWindow().setFullScreen(false);
    }
}

function HyperIntensiveMode() {
    if (EditorMode == 0) {
        $("#right-component").toggle();
        $("#my-divider").toggle();
        $("header").toggle();
        $("footer").toggle();
        $("#left-component").css("right", "0px");
        $("#container").css("padding", "0");
        browserWindow.getFocusedWindow().setFullScreen(true);
    }

}


var sendDirPath = setInterval(function(){
    webview.send("novelInfo",novelInfo);
},1000);


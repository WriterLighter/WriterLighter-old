var webview;

var dirPath = "";

$(function () {
    webview = document.getElementById('mainWebview');

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
        $("#left-component").css("right", "0px");
        $("#container").css("padding", "0");
        EditorMode = 1;
        $.amaran({
            "message": "超集中モード起動\n解除はF11キー"
        });
    } else {
        $("#left-component").css("right", "260px");
        $("#container").css("padding", "25px 0 25px 0");
        EditorMode = 0;
    }
    /*toggleFullScreen($("#left-component"));*/




}

function HyperIntensiveMode() {
    if (EditorMode == 0) {
        $("#right-component").toggle();
        $("#my-divider").toggle();
        $("header").toggle();
        $("footer").toggle();
        $("#left-component").css("right", "0px");
        $("#container").css("padding", "0");
    }

}

function toggleFullScreen(elem) {
    elem = elem[0];
    if (isFullScreen) {
        if (document.fullScreen || document.mozFullScreen || document.webkitIsFullScreen || document.msFullScreen) {
            if (document.cancelFullscreen) {
                document.cancelFullscreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.msCancelFullscreen) {
                document.msCancelFullscreen();
            }
        } else {
            if (elem.requestFullscreen) {
                elem.requestFullscreen();
            } else if (elem.webkitRequestFullscreen) {
                elem.webkitRequestFullscreen();
            } else if (elem.mozRequestFullScreen) {
                elem.mozRequestFullScreen();
            } else if (elem.msRequestFullscreen) {
                elem.msRequestFullscreen();
            }
        }
    }
}

var sendDirPath = setInterval(function () {
    webview.send("dirPath", dirPath);
}, 1000);
$(function ()

    // 何か入力された時のイベント


    $("#input_txt").keyup(function () {
        count();

    });

    $('div.split-pane').splitPane();




});

var csObj = new Object();
csObj.theme= "dark";

$(window).load(function(){
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

var isIntensiveMode = false;

function IntensiveMode() {
    $("#right-component").toggle();
    $("#my-divider").toggle();
    $("header").toggle();
    $("footer").toggle();
    if (!isIntensiveMode) {
        $("#left-component").css("right", "0px");
        $("#container").css("padding", "0");
        isIntensiveMode = true;
        $.amaran({"message":"超集中モード起動\n解除はF11キー"});
    } else {
        $("#left-component").css("right", "260px");
        $("#container").css("padding", "25px 0 25px 0");
        isIntensiveMode = false;
    }
    /*toggleFullScreen($("#left-component"));*/




}


var sendDirPath = setInterval(function(){
    webview.send("novelInfo",novelInfo);
},1000);

function toggleFullScreen(elem) {
    elem = elem[0];
    if( isFullScreen ){
        if( document.fullScreen || document.mozFullScreen ||  document.webkitIsFullScreen || document.msFullScreen ) {
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

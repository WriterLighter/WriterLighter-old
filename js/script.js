var webview;

$(function () {
    webview = document.getElementById('mainWebview');

     // 何か入力された時のイベント


    $("#input_txt").keyup(function(){
        count();

    });

    $('div.split-pane').splitPane();


});

function toggleWritingMode() {
    $("#input_txt").toggleClass("write-vertical");
}

function toggleWebviewDevTools(){
    var webview = $("#mainWebview");
    if(webview.isDevToolsOpened()){
        webview.closeDevTools();
    }else{
        webview.openDevTools();
    }
}

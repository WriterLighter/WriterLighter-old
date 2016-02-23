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
    console.log(document.getElementById("writingMode").checked);
if(document.getElementById("writingMode").checked){
    $("#input_txt").addClass("write-vertical");
}else{
    $("#input_txt").removeClass("write-vertical");
}
}

function toggleWebviewDevTools(){
    var webview = $("#mainWebview");
    if(webview.isDevToolsOpened()){
        webview.closeDevTools();
    }else{
        webview.openDevTools();
    }
}

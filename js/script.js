

$(function () {
    var webview = $("#mainWebview");

     // 何か入力された時のイベント


    $("#input_txt").keyup(function(){
        count();

    });

    $('div.split-pane').splitPane();


});

function toggleWritingMode() {
    $("#input_txt").toggleClass("write-vertical");
}



$(function () {
    var webview = $("#mainWebview");

     // 何か入力された時のイベント


    $("#input_txt").keyup(function () {
        count();

    });

    $('div.split-pane').splitPane();


});

function toggleWritingMode() {
    $("#input_txt").toggleClass("write-vertical");
}

function IntensiveMode() {
    $("#right-component").toggle();
    $("#my-divider").toggle();
    if ($("#left-component").css("right") == "260px") {
        $("#left-component").css("right", "0px");
    } else {
        $("#left-component").css("right", "260px");
    }

}
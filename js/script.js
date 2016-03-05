$(function () {

    // 何か入力された時のイベント
    $("#input_txt").keyup(function () {
        count();
        if (inputTxt.innerText !== formerFile && Edited !== true) {
            Edited = true;
            document.title = "*" + document.title;
        }
    });

    $('div.split-pane').splitPane();

    window.onbeforeunload = function (e) {
        if (Edited) {
            var choice = dialog.showMessageBox(
                remote.getCurrentWindow(), {
                    type: 'question',
                    buttons: ['Yes', 'No'],
                    title: '確認',
                    message: novelName + "はまだ保存されていません。\n閉じてもよろしいですか？"
                });

            return choice === 0;
        };
    }


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
    if (webview.isDevToolsOpened()) {
        webview.closeDevTools();
    } else {
        webview.openDevTools();
    }
}

function IntensiveMode() {
    if (EditorMode == 0) {
        $("#right-component").toggle(false);
        $("#my-divider").toggle(false);
        $("header").toggle(false);
        $("footer").toggle(false);
        $("#left-component").css("right", "0px")
            .css("margin", "0px");
        $("#container").css("padding", "0");
        EditorMode = 1;
        browserWindow.getFocusedWindow().setFullScreen(true);
        $.amaran({
            "message": "超集中モード起動\n解除はF11キー"
        });
    } else {
        $("#right-component").toggle(true);
        $("#my-divider").toggle(true);
        $("header").toggle(true);
        $("footer").toggle(true);
        $("#left-component").css("right", "260px")
            .css("margin-right", "5px");
        $("#container").css("padding", "25px 0 25px 0");
        EditorMode = 0;
        browserWindow.getFocusedWindow().setFullScreen(false);
    }
}

function HyperIntensiveMode() {
    //window.promptが使えないんだとさ。やっぱりモーダルウィンドウ使うほかないのか
    /*if (EditorMode == 0 || EditorMode == 1) {
        IntensivePasswd = window.prompt("カンヅメモード用のパスワードを設定してください", "パスワード:");
        if (window.confirm("カンヅメモードを開始します。\n解除するには、パスワードを入力する必要があります")) {
            $("#right-component").toggle(false);
            $("#my-divider").toggle(false);
            $("header").toggle(false);
            $("footer").toggle(false);
            $("#left-component").css("right", "0px");
            $("#container").css("padding", "0");
            browserWindow.getFocusedWindow().setFullScreen(true);
            $.amaran({
            "message": "カンヅメモード起動\n解除はF11キー"
        });
        }

    } else {
        if (window.prompt("カンヅメモードを解除します。\nパスワードを入力してください", "パスワード:") == IntensivePasswd) {
            $("#right-component").toggle(true);
            $("#my-divider").toggle(true);
            $("header").toggle(true);
            $("footer").toggle(true);
            $("#left-component").css("right", "260px")
                .css("margin-right", "5px");
            $("#container").css("padding", "25px 0 25px 0");
            EditorMode = 0;
            browserWindow.getFocusedWindow().setFullScreen(false);
            $.amaran({
            "message": "カンヅメモードを解除しました。"
        });
        }else{
            window.alert("パスワードが違います");
        }

    }*/

}


var sendDirPath = setInterval(function () {
    webview.send("novelInfo", novelInfo);
}, 1000);

function statusMsg(msg, time) {
    $("#status").html(msg);
    if (time !== undefined) {
        var statusMsg = setTimeout(function () {
            $("#status").html("");
        }, time);
    }
}
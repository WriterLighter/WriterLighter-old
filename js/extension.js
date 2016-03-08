
function OpenExt() {
    for (var i = 0; i < ext_tabs.length; i++) {
        if (ext_tabs[i].checked) {
            openedExt = ext_tabs[i].value;
            // TODO: グローバル拡張機能かユーザー拡張機能かで条件分け
            var Extdir = __dirname + "/extensions/";
            var view = "index.html";
            var url = "file://" + Extdir + openedExt + "/" + view;
            webview.setAttribute("src", url);

            console.log("tab changed");
            console.log(openedExt);
        }
    }
}

$(function () {
    for (var i = 0; i < ext_tabs.length; i++) {
        ext_tabs[i].onchange = function () {
            console.log("changed");
            OpenExt();
        };
    }
})


$(function(){
webview.addEventListener('ipc-message', function (event) {
    switch (event.channel) {
    case "OpenChapter":
        var chaptername = event.args[0];
        console.log(chaptername);
        chapterName = chaptername;
        readFile(dirPath + "/本文/" + chaptername + ".txt");
        break;

    case "getParam":
        sendParam = event.args[0];
        break;

    case "saveCharacter":
    console.log(event.args[0]);
    break;
    }
});
});

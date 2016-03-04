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
    for (var i = 0; 1 < ext_tabs.length; i++) {
        ext_tabs[i].onchange = function () {
            console.log("changed");
            OpenExt();
        };
    }
})

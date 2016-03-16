function OpenExt() {
    for (var i = 0; i < ext_tabs.length; i++) {
        if (ext_tabs[i].checked) {
            openedExt = ext_tabs[i].value;
            // TODO: グローバル拡張機能かユーザー拡張機能かで条件分け
            var Extdir = __dirname + "/extensions/";
            var view = "index.html";
            var url = "file://" + Extdir + openedExt + "/" + view;
            writerlighter.webview.setAttribute("src", url);

            console.log("tab changed");
            console.log(openedExt);
        }
    }
}

writerlighter.sendParamInterval = setInterval(function () {
     var newVar = {};
     for (var i in writerlighter.sendVer) {
         newVar[i] = eval("writerlighter." + i);
     }
     if (JSON.stringify(writerlighter.sendVer) !== JSON.stringify(newVar)) {
         console.log(newVar);
         writerlighter.sendVer = newVar;
         writerlighter.webview.send("RequestedVariable", writerlighter.sendVer);
     }
 }, 500);

$(function () {
    for (var i = 0; i < writerlighter.ext_tabs.length; i++) {
        writerlighter.ext_tabs[i].onchange = function () {
            console.log("changed");
            OpenExt();
        };
    }
})

$(function () {
    writerlighter.webview.addEventListener('ipc-message', function (event) {
        switch (event.channel) {
        case "OpenChapter":
            writerlighter.chapterName = event.args[0];
            console.log(writerlighter.chapterName);
            readFile(writerlighter.dirPath + "/本文/" + writerlighter.chapterName + ".txt");
            break;

        case "getVariable":
            writerlighter.sendVer = {};
            for (var i = 0; i < event.args[0].length; i++) {
                writerlighter.sendVer[event.args[i]] = null;
            }
            break;

        case "saveCharacter":
            console.log(event.args[0]);
            break;
        }
    });
});

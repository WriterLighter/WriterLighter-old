//var webview = document.getElementById('mainWebview');


$(function(){
webview.addEventListener('ipc-message', function (event) {
    switch (event.channel) {
    case "OpenChapter":
        var chaptername = event.args[0];
        console.log(chaptername);
        chapterName = chaptername;
        readFile(dirPath + "/本文/" + chaptername + ".txt");
        break;
    }
});
});

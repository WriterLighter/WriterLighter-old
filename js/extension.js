//var webview = document.getElementById('mainWebview');



webview.addEventListener('ipc-message', function (event) {
    switch (event.channel) {
    case "chapterOpen":
        var chaptername = event.args[0];
        console.log(chaptername);
        readFile(dirPath + "/本文/" + chaptername + ".txt");
        break;
    }
});

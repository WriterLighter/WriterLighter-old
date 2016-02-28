//var webview = document.getElementById('mainWebview');



webview.addEventListener('ipc-message', function (event) {
    console.log(event);
    console.log(event.channlel);
    switch (event.channel) {
    case "chapterName":
        var chaptername = event.args[0];
        console.log(chaptername);
        readFile(dirPath + "/本文/" + chaptername + ".txt");
        break;
    }
});

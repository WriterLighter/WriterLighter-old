webview.addEventListener('ipc-message', function (event) {
    switch (event.channel) {
    case "chapterOpen":
        var chaptername = event.args[0];
            readFile(dirPath + "本文/" + chaptername + ".txt");
        break;
    }
});

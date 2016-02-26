var ipc = require("electron").ipcRenderer;
var fs = require('fs');
var $ = require('./../../js/jquery-1.12.0.min.js');

var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";


console.log(dirPath);
ipc.on('dirPath', function (event, path) {
    if (path !== "" && path != dirPath) {
        dirPath = path;
        var index = validateJSON(fs.readFileSync(path + '/index.json', 'utf8'));
        for (var i = 0; i < index.chapter.length; i++) {
            $("#cahpter-list").append("<li class=\"chapter\"><a>" + index.chapter[i] + "</a></li>");
        }
    }
});

function validateJSON(text) {
    var obj = null;
    try {
        obj = JSON.parse(text);
        return obj;
    } catch (O_o) {;
    }
    // try eval(text)
    try {
        obj = eval("(" + text + ")");
    } catch (o_O) {
        console.log("ERROR. JSON.parse failed");
        return null;
    }
    console.log("WARN. As a result of JSON.parse, a trivial problem has occurred");
    return obj; // repaired
}

$("#cahpter-list > li.chapter > a").on("click", function () {
    var chaptername = this.html();
    console.log(chaptername);
    ipc.sendToHost('chapterOpen', chaptername);
});

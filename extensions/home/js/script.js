var ipc = require("electron").ipcRenderer;
//var ipc = require('ipc');
var fs = require('fs');

var fs = require("fs");

//var json = validateJSON( fs.readFileSync("hoge.json", "UTF-8") );

// JSON の評価を行う、JSON.parseでエラーになる場合は、jsとしてevalする
function validateJSON(text) {
    var obj = null;

    try {
        obj = JSON.parse( text );
        return obj;
    } catch (O_o) {
        ;
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

var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";


console.log(dirPath);
ipc.on('dirPath', function (event, path) {
    if (path !== "") {
        if (path != dirPath) {
            console.log(dirPath);
            dirPath = path;
            var index = validateJSON(fs.readFileSync(path + '/index.json', 'utf8'));
            console.log(index);
            for (var i = 0; i < index.chapter.length; i++) {
                console.log(document.getElementById("chapter-list"));
                console.log(index.chapter[i]);
            }
        }
    }
});

console.log(dirPath);
/*
$("#cahpter-list > li").on("click", function () {
    var chaptername = this.html();
    ipc.sendToHost('chapterOpen', chaptername);
});
*/

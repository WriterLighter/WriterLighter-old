var ipc = require("electron").ipcRenderer;
//var ipc = require('ipc');


var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";


console.log(dirPath);
ipc.on('dirPath', function (event,path) {
    console.log(dirPath);
    console.log(path);
    console.log(path !== "" || path != dirPath);
    if(path !== "" || path != dirPath){
        dirPath = path;
        console.log(dirPath);
        /*
        var index = require(path + '/index.json');
        console.log(index);
        for (var i = 0; i < index["chapter"].length; i++) {
            console.log(document.getElementById("chapter-list"));
        }
        */
    }
});

console.log(dirPath);
/*
$("#cahpter-list > li").on("click", function () {
    var chaptername = this.html();
    ipc.sendToHost('chapterOpen', chaptername);
});
*/

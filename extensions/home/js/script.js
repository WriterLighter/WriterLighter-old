console.log("start");

var ipc = require('ipc');

var dirPath = "";
var filePath = "";
var novelName = "";
var chapterName = "";


ipc.on('dirPath', function (path) {
    console.log(path);
    if (dirPath !== path) {
        dirPath = path;
        //var index = require(path + '/index.json');
        //for (var i = 0; i < index["chapter"].length; i++) {
        //    $("#cahpter-list").append("<li class=\"chapter\">" + index["chapter"][i] + "</li>");
      //  }
    }
});
console.log("second");

$("#cahpter-list > li").on("click", function () {
    var chaptername = this.html();
    ipc.sendToHost('chapterOpen', chaptername);
});

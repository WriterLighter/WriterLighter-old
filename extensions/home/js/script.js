var ipc = require('ipc');

ipc.on('openNovel', function (path) {
    var index = require(path + 'index.json');
    for (var i = 0 ; i < index["chapter"].length ; i++) {
        $("#cahpter-list").append("<li class=\"chapter\">" + index["chapter"][i] + "</li>");
    }
});

$("#cahpter-list > li").on("click",function(){
    var chaptername = this.html();
    ipc.sendToHost('chapterOpen',chaptername);
});

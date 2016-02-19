function wc() {

    var txtvalue = $("#input_txt").text();

    var NoC = txtvalue.length;
    var BoC = encodeURI(txtvalue).replace(/%[0-9A-F]{2}/g, '*').length;
    //var line = value.split("\n").length;
    var line = $("#input_txt").html().split("<br>").length - 1;
    line = line + $("#input_txt").html().split("<div>").length - 1;
    line = ++line;

    $("#wc").html(NoC + "文字");
    $("#line").html(line + "行");
    if (BoC >= 1024) {
        $("#byte").html(Math.floor(BoC / 1024) + "キロバイト");
    } else {
        $("#byte").html(BoC + "バイト");
    }
}

$(function () {

    /*
     * 何か入力された時のイベント
     */


    $("#input_txt").keyup(function () {

        var txtvalue = $("#input_txt").text();

        var NoC = txtvalue.length;
        var BoC = encodeURI(txtvalue).replace(/%[0-9A-F]{2}/g, '*').length;
        //var line = value.split("\n").length;
        var line = $("#input_txt").html().split("<br>").length　 - 1;
        line = line + ($("#input_txt").html().split("<div>").length - 1);
        line = line - ($("#input_txt").html().split("<div><br></div>").length - 1);
        line = ++line;
        //if(line = 0){line = ++line;}

        $("#wc").html(NoC + "文字");
        $("#line").html(line + "行");
        if (BoC >= 1024) {
            $("#byte").html(Math.floor(BoC / 1024) + "キロバイト");
        } else {
            $("#byte").html(BoC + "バイト");
        }
    });


    $('div.split-pane').splitPane();
});

function toggleWritingMode() {
    $("#input_txt").toggleClass("write-vertical");
}

function findAllInText(Str, Keyword) {
    var KeywordNum = Keyword.length;
    var start = 0;
    var res = [];
    while (true) {
        var i = Str.indexOf(Keyword, start);
        if (i >= 0) {
            res.push(i);
            start = i + KeywordNum;
        } else {
            return res;
        }
    }
}

function insert(Str, insPos, insStr) {
    return Str.slice(0, insPos) + insStr + Str.slice(insPos);
}

function SearchAndHighlight(Str, Keyword) {
    var res = Str;
    var KeywordNum = Keyword.length;
    var sres = findAllInText(Str, Keyword);
    for (var i = sres.length - 1; i >= 0; --i) {
        var start = sres[i];
        var end = start + KeywordNum;
        res = insert(res, end, "</span>");
        res = insert(res, start, "<span class='highlighted'>");
    }
    return res;
}

//ハイライト除去関数(未実装)
/*function HighlightRemove{
    
}*/

function Search() {
    var Keyword = $("#keyword").val();
    if (!(Keyword == "")) { //検索窓になにも入力されていない時の誤動作を防ぐ !Keywordとかでifできないかと思ったけど無理だった
        
        var el = $("#input_txt");
        var before = el.html();
        var after = SearchAndHighlight(before, Keyword);
        el.html(after);
    }
}

//enterキーでの検索実行関数←いらなかった　次回コミット時にはこのコメントも消します
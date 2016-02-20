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
        res = insert(res, end, "</mark>");
        res = insert(res, start, "<mark class='highlighted'>");
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

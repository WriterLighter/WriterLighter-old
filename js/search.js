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

function Search() {
    var Keyword = $("#keyword").val();
    if (!(Keyword == "")) {
        writerlighter.inputTxt.innerHTML = SearchAndHighlight(writerlighter.valuehtml, Keyword);

    }
}

function RemoveHighlight(){
    writerlighter.inputTxt.innerHTML = writerlighter.valuehtml;
}

$(function(){
   writerlighter.inputTxt.onfocus = function(){
      RemoveHighlight();
   } ;
});

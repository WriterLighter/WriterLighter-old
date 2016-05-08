var client = require('cheerio-httpcli');

//現在使用不可
function translate(word, usingSite) {
    switch (usingSite) {
    case "weblio":
        var returnword = trans_weblio(word);
        return returnword;
    }
}

//weblio翻訳
//TODO:同期通信でうまくいかない
function trans_weblio(word) {
    var word_enc = encodeURIComponent(word);
    var searchURL = 'http://ejje.weblio.jp/content/' + word_enc;
    var returnword;
    var cnt;
    console.log(searchURL);


    client.fetch(searchURL, function (err, $, res) {
        console.log(res.headers);
        console.log($('title').text());
        console.log($('.summaryM').text());
        returnword = $('.summaryM').text().split("\n")[0].substr(4).split("、 " && "; ");
        console.log(returnword);
    });
    
    return returnword;



    /* console.log(p.$('title').text());
     returnword = p.$('.summaryM').text().split("\n")[0].substr(4).split("、 " && "; ");*/
    /*console.log(returnword);
    return returnword;*/
}

function f() {

}
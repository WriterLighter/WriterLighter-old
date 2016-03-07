
/*
 * コンテキストメニュー
 */

var contextmenu = new Menu();
//label:メニューに表示する名前
//click:選択時の処理(中に関数を書ける)
contextmenu.append(new MenuItem(validateJSON(fs.readFileSync('./json/contextmenu.json', 'utf8'))));

//右クリックされた場合に呼ばれる
window.addEventListener('contextmenu', function (e) {
    //コンテキストメニューの表示
    contextmenu.popup(remote.getCurrentWindow());
}, false);

/*
 * アプリケーションメニュー
 */

var template =validateJSON(fs.readFileSync('./json/appmenu.json', 'utf8'));


//以下二つでtemplateの内容を反映させる
var menu = Menu.buildFromTemplate(template);
Menu.setApplicationMenu(menu);

/*
 * 選択時メニュー
 */
// onSelectがよくわからんのでコメントアウト
/*
var selectedmenu = new Menu();
//label:メニューに表示する名前
//click:選択時の処理(中に関数を書ける)
selectedmenu.append(new MenuItem({
    label: 'Search on Google.',
    click: function () {
        alert("Sorry. This Function is Developing now...");
    }
}));

$("#input-txt").onSelect(selectedmenu.popup(remote.getCurrentWindow()));
*/


/*
 * コンテキストメニュー
 */

var contextmenu = new Menu();
//label:メニューに表示する名前
//click:選択時の処理(中に関数を書ける)
contextmenu.append(new MenuItem({
    label: 'Search on Google.',
    click: function () {
        alert("Sorry. This Function is Developing now...");
    }
}));

//右クリックされた場合に呼ばれる
window.addEventListener('contextmenu', function (e) {
    //コンテキストメニューの表示
    contextmenu.popup(remote.getCurrentWindow());
}, false);

/*
 * アプリケーションメニュー
 */

var template = [

    {
        label: 'File',
        submenu: [
            {
                label: 'Open',
                accelerator: 'CmdOrCtrl+O',
                click: function () {
                    openLoadFile();
                }
            },
            {
                label: 'Save',
                accelerator: 'CmdOrCtrl+S',
                click: function () {
                    saveFile();
                }
            },
            {
                label: 'Save as New File',
                accelerator: 'CmdOrCtrl+Shift+S',
                click: function () {
                    saveNewFile();
                }
            },
            {
                label: 'indensiveMode',
                accelerator: 'F11',
                click: function () {
                    IntensiveMode();
                }
            }
     ]
 },

    {
        label: 'Development Menu',
        submenu: [
            {
                label: 'Reload',
                accelerator: 'CmdOrCtrl+R',
                click: function () {
                    remote.getCurrentWindow().reload();
                }
            },
            {
                label: 'Toggle DevTools',
                accelerator: 'Alt+CmdOrCtrl+I',
                click: function () {
                    remote.getCurrentWindow().toggleDevTools();
                }
            }
                ]
}
];


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

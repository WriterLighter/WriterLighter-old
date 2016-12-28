let statusList;
module.exports = statusList = undefined;
class statusBar {
  static initClass() {
    statusList = {};
  }
  
  static register(name, val) {
    let $status;
    if (!document.getElementById(`statusbar-${name}`)) {
      $status =  $(`<li id='statusbar-${name}'>`).appendTo("#statusbar");
    } else {
      $status = $(`#statusbar-${name}`);
    }
    $status.html(val);
    return statusList[name] = val;
  }

  static get(name) {
    return statusList[name];
  }
}
statusBar.initClass();

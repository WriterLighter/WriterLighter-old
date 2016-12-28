let _show;
const EventEmitter2 = require("eventemitter2");

const defaultOptions = {
  show: true,
  type: "toast",
  messeage: "",
  timeout: 3000,
  complete: []
};

module.exports = _show = undefined;
let _hide = undefined;
class Popup extends EventEmitter2 {
  static initClass() {
    
    _show= (html, type)=>
      $("#popup")
        .html(html)
        .addClass("show")
        .addClass(type)
    ;
  
    _hide = function(val) {
      if (this.emit("hide", val)) {
        Popup.hide();
        return setTimeout(function() {
          return this.emit("hidden", val);
        }
        , $("#popup").css("transion"));
      }
    };
  }
  static hide() {
    $("#popup").removeClass("show");
    $("#popup.toast").removeClass("toast");
    return $("#popup.prompt").removeClass("prompt");
  }

  static isShowing() {
    return $("#popup").hasClass("show" || !$("#popup:hover").length);
  }
  
  constructor(options){
    this.show = this.show.bind(this);
    this.options = Object.assign({}, defaultOptions, options);
    this.options.show || this.show();
  }

  show() {
    let html;
    Popup.hide();
    const opts = this.options;
    switch (opts.type) {
      case "toast":
        _show.call(this, opts.messeage, opts.type);
        return setTimeout(() => {
          return _hide.call(this, opts.messeage);
        }
        , opts.timeout);

      case "prompt":
        if (typeof opts.messeage === "string") {
          html = `<input type='text' placeholder='${opts.messeage}'>`;
        } else {
          html = "<form>";
          opts.messeage.forEach((item, index)=> html += `<div><input type='text' placeholder='${item}'></div>`);
          html += "<input type='reset'><input type='submit' value='完了'><form>";
        }
        
        _show.call(this, html, opts.type);
        
        $("#popup>input[type='text']")
          .autocomplete({
            "source": opts.complete});
            

        if ($("#popup>input[type='text']").length === 1) {
          return $("#popup>input[type='text']")
            .focus()
            .on("blur",() => {
              if (!opts.forcing) {
                return Popup.hide();
              }
            }
          )
            .on("keydown", e=> {
              if (e.keyCode === 13) {
                if ($("#popup>input").val() === "") { return false; }
                return _hide.call(this, $("#popup>input").val());
              }
            }
          );
        } else {
          return $("#popup>form").on("submit", () => {
            const value = [];
            let uninput = false;
            $("#popup input[type='text']").each(function() {
              if ($(this).val() === "") { uninput = true; }
              return value.push($(this).val());
            });
            if (!uninput) {
              _hide.call(this, value);
            }
            return false;
          }
          );
        }
    }
  }
}
Popup.initClass();

"use strict"
let focusing      = 0;
const $searchInput  = $("#search-input");
const $searchResult = $("#search-result");

const $replaceInput = $("#replace-input")

let isHidden = true;

const $search   = $("#search");
const $sections = {
  search: $("#search-field"),
  replace: $("#replace-field")
};
const $options  = {
  inRegExp: $("#search-in-regexp"),
  matchCase: $("#search-match-case")
};

const search = module.exports = class {
  static search(keyword, options) {
    if (isHidden) {
      $sections.replace.css({display: "none"});
      $sections.search.css({display: "auto"});
      $search.css({height: $sections.search.position().top +
        $sections.search.innerHeight()
      });
      setTimeout(() => $search.css({height: "auto"})
      , parseFloat($search.css("transition-duration")) * 1000);
    }
    isHidden = false;

    wl.editor.setAutoHighlighter("search" ,{rule: search.getSearchRegExp(keyword, options)});
    this.focus(0);
  }

  static getSearchRegExp(keyword, options, setForm){
    if (keyword == null) { keyword = $searchInput.val(); }
    if (options == null) { options = {}; }
    if (setForm == null) { setForm = true; }
    options = Object.assign(
      Object.keys($options)
      .reduce((previous, current) => {
        previous[current] = $options[current].prop("checked");
        return previous;
      } , {})
    , options);

    if (setForm) {
      search.setSearchForm(keyword, options);
    }

    let flag = "mg";
    if (!options.matchCase) {
      flag += "i";
    }
    if (!options.inRegExp) {
      keyword = keyword.replace(/[\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|\/]/g, "\\$&");
    }

    if (keyword) { return new RegExp(keyword, flag); } else { return null; }
  }

  static setSearchForm(keyword, options){
    if (keyword == null) { keyword = $searchInput.val(); }
    if (options == null) { options = {}; }
    if (keyword !== $searchInput.val()) {
      $searchInput.val(keyword);
    }

    $searchInput.focus();

    return (() => {
      const result = [];
      for (let name in $options) {
        const $checkBox = $options[name];
        result.push($checkBox.prop("checked", options[name]));
      }
      return result;
    })();
  }

  static focus(index){
    const $highlights = $(wl.editor.getHighlightElement("search"))
      .children("mark");
    if(index === "next"){
      this.focus((focusing + 1) % $highlights.length);
      return;
    } else if(index === "back"){
      this.focus((focusing - 1 < 0 ? $highlights.length: focusing) - 1)
      return;
    }

    const $wrapper = $(wl.editor.getWrapper());
    focusing = index;
    let properties;
    const $highlight = $highlights
      .removeClass("focused")
      .eq(index)
      .addClass("focused")

    const highlightPosition = $highlight.position();

    for(let direction in highlightPosition){
      const size = direction === "top" ? "height" : "width";
      const scrollDirection = `scroll${direction[0].toUpperCase()}${direction.slice(1)}`;
      const scroll = $wrapper[scrollDirection]();
      if(
        scroll > highlightPosition[direction]
        || scroll + $wrapper[size]() < highlightPosition[direction] + $highlight[size]()
      ) {
        $wrapper[scrollDirection](highlightPosition[direction] - $wrapper[size]() / 2);
      }
    }
  }

  static replace(replacement, all=false){
    isHidden = false;
    $sections.replace.css({display: ""});
    $sections.search.css({display: ""});
    $search.animate({height: $sections.replace.position().top +
      $sections.replace.innerHeight()
    });
    setTimeout(() => $search.css({height: "auto"})
    , parseFloat($search.css("transition-duration")) * 1000);

    const query = this.getSearchRegExp();
    if(!query) return; 
    const src = wl.editor.getText();
    const typeOfReplacement = ({}).toString.call(replacement);
    let times = -1;

    wl.editor.setText(wl.editor.getText().replace(query, (...args) => {
      if(++times === focusing || all){
        switch(typeOfReplacement){
          case "[object String]":
            return replacement.replace(/\$([$&`']|[0-9]+)/, (m, $0) => {
              if (isNaN($0)) {
                switch ($0) {
                  case "$":
                    return "$";
                  case "&":
                    return args[0];
                  case "`":
                    return src.slice(0, args[args.length - 2]);
                  case "'":
                    return src.slice(args[args.length - 2] + args[0].length);
                }
              } else {
                return args[$0] != null ? args[$0] : "";
              }
            })

          case "[object Function]":
            return replacement(...args);

          default:
            return args[0];
        }
      } else {
        return args[0];
      }
    }))
    wl.search.focus(focusing);
  }
};

const handleSearchFormChange = e => search.search();

$searchInput.on("input", handleSearchFormChange);

$("#search-focus-next").on("click", () => wl.search.focus("next"));
$("#search-focus-back").on("click", () => wl.search.focus("back"));

$("#replace").on("click",
  () => wl.search.replace($replaceInput.val(), false))

$("#replace-all").on("click",
  () => wl.search.replace($replaceInput.val(), true))

for (let name in $options) {
  const $checkBox = $options[name];
  $checkBox.on("change", handleSearchFormChange);
}


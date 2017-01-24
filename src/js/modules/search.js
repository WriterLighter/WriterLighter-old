"use strict"
let focusing      = 0;
const $searchInput  = $("#search-input");
const $searchResult = $("#search-result");

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

    return wl.editor.setAutoHighlighter("search" ,{rule: search.getSearchRegExp(keyword, options)});
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
};

const handleSearchFormChange = e => search.search();

$searchInput.on("input", handleSearchFormChange);

for (let name in $options) {
  const $checkBox = $options[name];
  $checkBox.on("change", handleSearchFormChange);
}


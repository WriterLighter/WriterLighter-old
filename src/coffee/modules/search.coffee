focusing      = 0
$searchInput  = $ "#search-input"
$searchResult = $ "#search-result"

isHidden = true

$search   = $ "#search"
$sections =
  search: $ "#search-field"
  replace: $ "#replace-field"
$options  =
  inRegExp: $ "#search-in-regexp"
  matchCase: $ "#search-match-case"

module.exports = class search
  @search = (keyword, option) ->
    if isHidden
      $sections.replace.css display: "none"
      $sections.search.css display: "auto"
    isHidden = false

    if keyword?
      $searchInput.val if ({}).toString.call(keyword) is "[object RegExp]"
        keyword.source
      else
        keyword


    if option?
      for key, check of $options
        check.prop "checked", option[key] ? false
    else
      option = {}
      for key, check of $options
        option[key] = check.prop "checked"

    flg = "mg"
    unless option.match
      flg += "i"
    unless option.inRegExp
      keyword = keyword.replace /[\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|\/]/g, "\\$&"

    editor.setHighlight "search" ,rule:new RegExp(keyword, flg), enabled: true
editor = require './editor'

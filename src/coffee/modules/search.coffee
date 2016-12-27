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
      $search.css height: $sections.search.position().top +
        do $sections.search.innerHeight
      setTimeout ->
        $search.css height: "auto"
      , parseFloat($search.css "transition-duration") * 1000
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

  @getSearchRegExp = (keyword, options={})->
    options = Object.assign (Object.keys $options
      .reduce (previous, current) ->
        previous[current] = $options[current].prop "checked"
      , {})
    , options

    flag = "mg"
    unless option.match
      flag += "i"
    unless option.inRegExp
      keyword = keyword.replace /[\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|\/]/g, "\\$&"

    new RegExp keyword, flag

  @setSearchForm = (keyword, options={})->
    if keyword isnt do $searchInput.val
      $searchInput.val keyword

    for name, $checkBox of $options
      $checkBox.prop "checked", options[name]

editor = require './editor'

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

    editor.setHighlight "search" ,rule: do search.getSearchRegExp

  @getSearchRegExp = (keyword=$searchInput.val(), options={}, setForm=true)->
    options = Object.assign (Object.keys $options
      .reduce (previous, current) ->
        previous[current] = $options[current].prop "checked"
      , {})
    , options

    if setForm
      search.setSearchForm keyword, options

    flag = "mg"
    unless option.match
      flag += "i"
    unless option.inRegExp
      keyword = keyword.replace /[\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|\/]/g, "\\$&"

    if keyword then new RegExp keyword, flag else null

  @setSearchForm = (keyword=$searchInput.val(), options={})->
    if keyword isnt do $searchInput.val
      $searchInput.val keyword

    for name, $checkBox of $options
      $checkBox.prop "checked", options[name]

editor = require './editor'

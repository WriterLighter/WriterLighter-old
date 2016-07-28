editor = require './editor'

module.exports = class search
  focusing  = 0
  $search   = $ "#search"
  $all      = $ "#search-result-all"
  $focusing = $ "#search-focusing"

  @highlight: (keyword, className = "")	->

    findAllInText = (text, keyword) ->
      start = 0
      _res = []
      while true
        i = text.indexOf(keyword, start)
        if i >= 0
          _res.push i
          start = i + keyword.length
        else
          _res

    insert= (str, insPos, insStr)->
      str.slice(0, insPos) + insStr + str.slice(insPos)

    html = editor.getText()
    res = findAllInText html, keyword
    res.concat()
      .reverse()
      .forEach (start ,index)->
      end = start + keyword.length
      res = insert(html, end, "</mark>")
      res = insert(html, start, "<mark class='#{className}'>")
    editor.setHTML html
    res

  @focus:(index = 0)->
    res = $("mark.searched").length
    switch typeof index
      when "number"
        focusing = index % res
        $focusing.html(focusing + 1)
        $("mark.focused").removeClass("focused")
        pos = $("mark.searched").eq(focusing).addClass("focused").position()
        if editor.direction.is is "vertical"
          $("#input-text").scrollTop(pos.top - ($("#input-text").height() / 2))
        else
          $("#input-text").scrollLeft(pos.left - ($("#input-text").width() / 2))

      when "string"
        switch index
          when "next"
            search.focus(focusing + 1)
          when "back"
            search.focus(focusing - 1)
    focusing

  @search:(keyword)->
    $search.addClass("show")
    $("#search input[type='search']")
      .val keyword
      .focus()
    if keyword? and keyword isnt ""
      sres = search.highlight(keyword, "searched")
      unless sres.length is 0
        $all.html sres.length
        search.focus()
      else
        $("#search-result-all, #search-focusing").html 0
        $("#search-result").css color: "#f00"

  @nohighlight: ()->
    $('#search').removeClass('show')
    $("#input-text").html $("#input-text").text()
      .focus()

  $("#input-text").on "focus", ()->
    search.nohighlight()

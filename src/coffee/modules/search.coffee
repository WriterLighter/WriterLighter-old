module.exports =
  highlight: (Keyword, className = "")	->

    findAllInText = (text, keyword) ->
      start = 0
      _res = []
      while true
        i = text.indexOf(keyword, start)
        if i >= 0
          _res.push i
          start = i + keyword.length
        else
          return _res

    insert= (str, insPos, insStr)->
      str.slice(0, insPos) + insStr + str.slice(insPos)

    res = wl.editor.input.innerText
    sres = findAllInText res, Keyword
    rres = sres
    rres.reverse()
    rres.forEach (start ,index)->
      end = start + Keyword.length
      res = insert(res, end, "</mark>")
      res = insert(res, start, "<mark class='#{className}'>")
    wl.editor.input.innerHTML = res
    sres

  focus:(index = 0)->
    res = $("mark.searched").length
    switch typeof index
      when "number"
        wl.search.forcusing = index % res
        $("#search .focused").html(wl.search.forcusing + 1)
        $("mark.focused").removeClass("focused")
        pos = $("mark.searched").eq(index%res).addClass("focused").position()
        if wl.editor.direction.is is "vertical"
          $("#input-text").scrollTop(pos.top + $("#input-text").scrollTop() - ($("#input-text").height() / 2))
        else
          $("#input-text").scrollLeft(pos.left + $("#input-text").scrollLeft() - ($("#input-text").width() / 2))

      when "string"
        switch index
          when "next"
            wl.search.focus(wl.search.forcusing + 1)
          when "back"
            wl.search.focus(wl.search.forcusing - 1)

  search:(keyword)->
    unless keyword?
      $("#search").addClass("show")
      $("#search input[type='search']").focus()
    else
      sres = wl.search.highlight(keyword, "searched")
      unless sres.length is 0
        $("#search .all").html sres.length
        wl.search.focus()

  nohighlight: ()->
    $('#search').removeClass('show')
    $("#input-text").html $("#input-text").text()
      .focus()

$ ->
  $("#input-text").on "focus", ()->
    wl.search.nohighlight()

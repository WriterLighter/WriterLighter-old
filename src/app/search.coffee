wl.search =
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
    sres.forEach (start ,index)->
      end = start + Keyword.length
      res = insert(res, end, "</mark>")
      res = insert(res, start, "<mark class='#{className}'>")
    wl.editor.input.innerHTML = res


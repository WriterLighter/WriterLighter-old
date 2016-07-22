module.exports =
  count:->
    val = wl.editor.input.innerText
    wl.counter.letter = val.length
    wl.counter.line   = val.split("\n").length
    wl.counter.byte   = encodeURIComponent(val).replace(/%../g,"x").length

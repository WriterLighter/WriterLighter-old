wl.statusbar =
  reload: ()->
    setTimeout ->
      val = wl.editor.input.innerText
      wl.counter.count()
      $("footer .letter").html wl.counter.letter + "文字"
      $("footer .line"  ).html wl.counter.line + "行"
      $("footer .byte"  ).html wl.counter.byte + "バイト"
    , 0

$ ->
  wl.statusbar.reload()

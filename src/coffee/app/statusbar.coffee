wl.statusbar =
  reload: ()->
    setTimeout ->
      val = wl.editor.input.innerText
      wl.counter.count()
      $("footer .letter").html wl.counter.letter + "文字"
      $("footer .line"  ).html wl.counter.line + "行"
      if wl.counter.byte >= 1024
        kb = ((Math.floor(wl.counter.byte / 1024 * 10)) / 10) + "キロバイト"
      else
        kb = wl.counter.byte + "バイト"
      $("footer .byte"  ).html kb
    , 0

$ ->
  wl.statusbar.reload()

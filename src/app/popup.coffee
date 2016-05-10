wl.popup = class popup
  
  hide: ->
    $("#popup").removeClass("show")
  
  _show= (html)->
    $("#popup")
      .html html
      .addClass "show"
  
  constructor: (@type = "toast", @messeage = "", @callback = ((m)-> console.log(m)), @timeout = 3000)->

  show: =>
    switch @type
      when "toast"
        _show.call @, @messeage
        setTimeout( =>
          @hide()
          @callback(@messeage)
        , @timeout)

      when "prompt"
        _show.call @,  "<input type='text' placeholder='#{@messeage}'>"
        $("#popup>input[type='text']")
          .focus()
          .on("blur",=>
            @hide()
          )
          .on("keydown", (e)=>
            if e.keyCode==13
              @hide()
              @callback($("#popup>input").val())
          )



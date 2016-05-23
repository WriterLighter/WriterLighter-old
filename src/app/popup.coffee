wl.popup = class popup
  
  hide: ->
    $("#popup").removeClass("show")
  
  _show= (html)->
    $("#popup")
      .html html
      .addClass "show"
  
  constructor: (@type = "toast", @messeage = "", @callback = ((m)-> console.log(m)), @timeout = 3000, @complete = [])->

  show: =>
    switch @type
      when "toast"
        _show.call @, @messeage
        setTimeout( =>
          @hide()
          @callback(@messeage)
        , @timeout)

      when "prompt"
        if typeof @messeage is "string"
          html = "<input type='text' placeholder='#{@messeage}'>"
        else
          html = "<form>"
          @messeage.forEach (item, index)->
            html += "<div><input type='text' placeholder='#{item}'></div>"
          html += "<input type='reset'><input type='submit' value='完了'><form>"
        
        _show.call @, html
        
        $("#popup>input[type='text']")
          .autocomplete
            "source": @complete
            

        if $("#popup>input[type='text']").length is 1
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
        else
          $("#popup>form").on "submit", =>
            @hide()
            value = []
            $("#popup input[type='text']").each ->
              value.push $(@).val()
            @callback value
            false

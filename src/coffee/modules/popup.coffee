module.exports = class popup
  @hide: ->
    $("#popup").removeClass "show"
    $("#popup.toast").removeClass "toast"
    $("#popup.prompt").removeClass "prompt"
  
  _show= (html, type)->
    $("#popup")
      .html html
      .addClass "show"
      .addClass type
  
  constructor: (@type = "toast", @messeage = "", @callback = ((m)-> console.log(m)), @timeout = 3000, @complete = [])->

  show: =>
    @hide
    switch @type
      when "toast"
        _show.call @, @messeage, @type
        setTimeout =>
          do @hide
          @callback @messeage
        , @timeout

      when "prompt"
        if typeof @messeage is "string"
          html = "<input type='text' placeholder='#{@messeage}'>"
        else
          html = "<form>"
          @messeage.forEach (item, index)->
            html += "<div><input type='text' placeholder='#{item}'></div>"
          html += "<input type='reset'><input type='submit' value='完了'><form>"
        
        _show.call @, html, @type
        
        $("#popup>input[type='text']")
          .autocomplete
            "source": @complete
            

        if $("#popup>input[type='text']").length is 1
          $("#popup>input[type='text']")
            .focus()
            .on "blur",=>
              unless @forcing
                do @hide
            .on "keydown", (e)=>
              if e.keyCode is 13
                if $("#popup>input").val() is "" then return false
                do @hide
                @callback $("#popup>input").val()
        else
          $("#popup>form").on "submit", =>
            value = []
            uninput = false
            $("#popup input[type='text']").each ->
              if $(@).val() is "" then uninput = true
              value.push $(@).val()
            unless uninput
              do @hide
              @callback value
            false

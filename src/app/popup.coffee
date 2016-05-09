wl.popup = class popup
  @content = ""
  @timeout = "1000"

  constructor: (@type = "toast")->

  show: ->
    switch @type
      when "toast"
        messeagehtml = @content
        setTimeout( ->
          $("#popup").removeClass "show"
          @content
        , @timeout)
      when "prompt"
        messeagehtml = "<input type='text'>"
        $("#popup>input").on("keydown", ->
          if window.event.keyCode==13
            $(@).val()
        )

    $("#popup")
      .html messeagehtml
      .addClass "show"

EventEmitter2 = require "eventemitter2"

defaultOptions =
  type: "toast"
  messeage: ""
  timeout: 3000
  complete: []

module.exports = class Popup extends EventEmitter2
  @hide: ->
    $("#popup").removeClass "show"
    $("#popup.toast").removeClass "toast"
    $("#popup.prompt").removeClass "prompt"
  
  _show= (html, type)->
    $("#popup")
      .html html
      .addClass "show"
      .addClass type

  _hide = (val) ->
    if @emit "hide", val
      do Popup.hide
      setTimeout ->
        @emit "hidden", val
      , $("#popup").css "transion"

  @isShowing:->
    $("#popup").hasClass "show" or not $("#popup:hover").length
  
  constructor: (options = {})->
    @options = Object.assign {}, defaultOptions, options

  show: =>
    do Popup.hide
    opts = @options
    switch opts.type
      when "toast"
        _show.call @, opts.messeage, opts.type
        setTimeout =>
          _hide.call @, opts.messeage
        , opts.timeout

      when "prompt"
        if typeof opts.messeage is "string"
          html = "<input type='text' placeholder='#{opts.messeage}'>"
        else
          html = "<form>"
          opts.messeage.forEach (item, index)->
            html += "<div><input type='text' placeholder='#{item}'></div>"
          html += "<input type='reset'><input type='submit' value='完了'><form>"
        
        _show.call @, html, opts.type
        
        $("#popup>input[type='text']")
          .autocomplete
            "source": opts.complete
            

        if $("#popup>input[type='text']").length is 1
          $("#popup>input[type='text']")
            .focus()
            .on "blur",=>
              unless opts.forcing
                do Popup.hide
            .on "keydown", (e)=>
              if e.keyCode is 13
                if $("#popup>input").val() is "" then return false
                _hide.call @, $("#popup>input").val()
        else
          $("#popup>form").on "submit", =>
            value = []
            uninput = false
            $("#popup input[type='text']").each ->
              if $(@).val() is "" then uninput = true
              value.push $(@).val()
            unless uninput
              _hide.call @, value
            false

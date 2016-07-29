module.exports = class statusBar
  statusList = {}
  
  @register = (name, val) ->
    unless document.getElementById "statusbar-#{name}"
      $status =  $("<li id='statusbar-#{name}'>").appendTo "#statusbar"
    else
      $status = $ "#statusbar-#{name}"
    $status.html val
    statusList[name] = val

  @get = (name) ->
    statusList[name]

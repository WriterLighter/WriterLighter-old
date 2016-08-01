module.exports = class event
  events = {}

  @on: (event, func)->
    event.split(" ").foreach (item,index) ->
      eventname = item.split(".")[0]
      namespace = item.split(".")[1]
      
      namespace = namespace ? "default"

      events[eventname] = events[eventname] ? {}
      events[eventname][namespace] = events[eventname][namespace] ? []
      events[eventname][namespace].push func

  @fire: (event, argments...) ->
    eventname = item.split(".")[0]
    namespace = item.split(".")[1]
    param = true
    
    if events[eventname]?
      fireQueue = []
      if namespace
        fireQueue = events[eventname][namespace]
      else
        for key, value of events[eventname]
          fireQueue.push value

      fireQueue.forEach (item, index) ->
        param = item.apply(@, argments) and param

    param

  @off: (event) ->
    event.split(" ").foreach (item,index) ->
      eventname = item.split(".")[0]
      namespace = item.split(".")[1]
      
    if namespace
      events[eventname] = {}
    else
      events[eventname][namespace] = []

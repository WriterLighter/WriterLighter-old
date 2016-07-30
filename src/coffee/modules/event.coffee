module.exports = class event
  events = {}

  @on: (event)->
    event.split(" ").forEach (item,index) ->
      eventname = item.split(".")[0]
      namespace = item.split(".")[1]
      
      namespace = namespace ? "default"

      events[eventname] = events[eventname] ? {}
      events[eventname][namespace] = events[eventname][namespace] ? []
      events[eventname][namespace].push func

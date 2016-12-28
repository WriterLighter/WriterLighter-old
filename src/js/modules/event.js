let events;
module.exports = events = undefined;
class event {
  static initClass() {
    events = {};
  }

  static on(event, func){
    return event.split(" ").forEach(function(item,index) {
      const eventname = item.split(".")[0];
      let namespace = item.split(".")[1];
      
      namespace = namespace != null ? namespace : "default";

      events[eventname] = events[eventname] != null ? events[eventname] : {};
      events[eventname][namespace] = events[eventname][namespace] != null ? events[eventname][namespace] : [];
      return events[eventname][namespace].push(func);
    });
  }

  static fire(event, ...argments) {
    const eventname = event.split(".")[0];
    const namespace = event.split(".")[1];
    let param = true;
    
    if (events[eventname] != null) {
      let fireQueue = [];
      if (namespace) {
        fireQueue = fireQueu.concat(events[eventname][namespace]);
      } else {
        for (let key in events[eventname]) {
          const value = events[eventname][key];
          fireQueue = fireQueue.concat(value);
        }
      }

      fireQueue.forEach(function(item, index) {
        return param = item.apply(this, argments) && param;
      });
    }

    return param;
  }

  static off(event) {
    event.split(" ").foreach(function(item,index) {
      let namespace;
      const eventname = item.split(".")[0];
      return namespace = item.split(".")[1];});
      
    if (namespace) {
      return events[eventname] = {};
    } else {
      return events[eventname][namespace] = [];
    }
  }
}
event.initClass();

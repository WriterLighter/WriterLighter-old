function validateJSON(text) {
    var obj = null;
    try {
        obj = JSON.parse(text);
        return obj;
    } catch (O_o) {;
    }
    // try eval(text)
    try {
        obj = eval("(" + text + ")");
    } catch (o_O) {
        console.log("ERROR. JSON.parse failed");
        return null;
    }
    console.log("WARN. As a result of JSON.parse, a trivial problem has occurred");
    return obj; // repaired
}

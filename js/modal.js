function modal_nomal(title,text){
$("head").append(<link rel="stylesheet" href="modal.css">
            <link rel="stylesheet" href="modal_nomal.css">);
$("body").append("<h1>"+title+"<h1>"+"<br >"+
            "<p>"+text+"</p>");
}
function modal(context){
$("head").append(<link rel="stylesheet" href="modal.css">)
$("body").append(context);
}
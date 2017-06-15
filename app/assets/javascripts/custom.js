// custom javascript code

$("document").ready(function() {
   // show confirmation box (in case the user clicked it by mistake instead of clicking 'save')
   $(".back-btn").on("click", function() {
    if(!confirm("Go back?")) {
        return false;
    }
   })


   $(".skills-input").select2({
    theme: "bootstrap",
    tags: true,
    tokenSeparators: [',']
});


});
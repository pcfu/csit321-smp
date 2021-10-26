$(document).ready(function () {
    let table;
    
      //link to stock show page
    $('#model-list tbody tr').css('cursor', 'pointer');
    $('#model-list tbody tr').on('click', 'td:not(.unclickable)', function () {
        var the_link = $(this).parent().attr("data-link");
        window.location = the_link;
    })


  
});
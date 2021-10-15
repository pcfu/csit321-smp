$(document).ready(function () {
    let table;
   
    
    $(".fav_row").each(function(){
        var buy = ($(this).find($('.fav_buythreshold')).html());
        var sell = ($(this).find($('.fav_sellthreshold')).html());
        var close = ($(this).find($('.fav_close')).html());
        if (parseFloat(close)<parseFloat(buy)){
            $(this).css('color','green');
            $(this).find($('.fav_buythreshold')).append(" [Buy Alert]");
    
        } else if (parseFloat(close)>parseFloat(sell)){
            $(this).css('color','red');
            $(this).find($('.fav_sellthreshold')).append(" [Sell Alert]");
        }
    });
    

   
      //  $('#fav-list tbody tr').setAttribute("class","table-danger");
  //  $('.unclickable').on('click', function (e) {
  //      e.stopPropagation(); 
  //  })

    // pop up alert button
/*     $('#unfav_button').on('click', function (e) {
        var r = confirm("Confirm unfavoriting?");
        if (r!=true){
            e.preventDefault();
        };
        $('.popup').show(); 
    })   */


    //link to stock show page
    $('#fav-list tbody tr').css('cursor', 'pointer');
    $('#fav-list tbody tr').on('click', 'td:not(.unclickable)', function () {
        var the_link = $(this).parent().attr("data-link");
        window.location = the_link;
    })


  
});
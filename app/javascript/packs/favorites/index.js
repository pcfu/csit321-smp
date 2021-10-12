$(document).ready(function () {
    let table;
   
    $('#fav-list tbody tr').css('cursor', 'pointer');
    $(".fav_row").each(function(){
        var buy = ($(this).find($('.fav_buythreshold')).html());
        var sell = ($(this).find($('.fav_sellthreshold')).html());
        var close = ($(this).find($('.fav_close')).html());
        if (parseFloat(close)<parseFloat(buy)){
            $(this).find($('.fav_buythreshold')).css('color','blue');
            $(this).find($('.fav_buythreshold')).append(" [Buy Alert]");
            $(this).find($('.fav_close')).css('color','blue');
    
        } else if (parseFloat(close)>parseFloat(sell)){
            $(this).find($('.fav_sellthreshold')).css('color','red');
            $(this).find($('.fav_sellthreshold')).append(" [Sell Alert]");
            $(this).find($('.fav_close')).css('color','red');
        }
    });
    

   
      //  $('#fav-list tbody tr').setAttribute("class","table-danger");

    $('#fav-list tbody tr').on('click', function () {
        window.location = this.dataset.link
    })



  
});
$(document).ready(function () {
    let table;


   
    $('#fav-list tbody tr').css('cursor', 'pointer');
    $('td[data-link').css('color','blue');


    $('td[data-link]').click(function(){
        window.location = this.dataset.link
    })
  
});
$(document).ready(function () {
    let table;


    $('#fav-list tbody').on('click', 'tr', function () {
    const stockId = $('#fav-list tr').data('fav').id;
   // const stockId = $(this).data();
    alert(stockId);
    window.location.href = `/stocks/${stockId}`;
    });
  
    $('#fav-list tbody tr').css('cursor', 'pointer');
  
});
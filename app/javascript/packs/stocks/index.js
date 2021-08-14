$(document).on('turbolinks:load', function () {
  let table;

  $.get('stocks.json', function (data) {
    table = window.$('#stocks-list').DataTable({
      aaData: data,
      columns: [
        { data: 'id' },
        { data: 'symbol' },
        { data: 'name' },
        { data: 'exchange' },
        { data: 'stock_type' },
        { data: 'description' },
      ]
    });

    $('#stocks-list tbody').on('click', 'tr', function () {
      const stockId = table.row(this).data().id;
      window.location.href = `/stocks/${stockId}`;
    });

    $('#stocks-list tbody tr').css('cursor', 'pointer');
    
  });
});



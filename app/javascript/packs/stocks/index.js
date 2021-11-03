$(document).ready(function () {
  let table;

  $.get('stocks.json', function (data) {
    table = window.$('#stocks-list').DataTable({
      aaData: data,
      columns: [
        { data: 'id' ,
          render: function (data, type, row, meta) {
            return meta.row + meta.settings._iDisplayStart + 1;}},
        { data: 'symbol' },
        { data: 'name' },
        { data: 'exchange' },
        { data: 'industry' },
      ]
    });

    $('#stocks-list tbody').on('click', 'tr', function () {
      const stockId = table.row(this).data().id;
      window.location.href = `/stocks/${stockId}`;
    });

    $('#stocks-list tbody tr').css('cursor', 'pointer');
  });
});

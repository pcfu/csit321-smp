$(document).on('turbolinks:load', function () {
  $.get('stocks.json', function (data) {
    window.$('#stocks-list').DataTable({
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
  });

  $(".clickable-row").click(function() {
    window.location = $(this).data("href");
  });
});

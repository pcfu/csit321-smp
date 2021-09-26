$(document).ready(function () {
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


  new TradingView.widget(
    {
      "width": 800,
      "height": 500,
      "symbol": "NASDAQ:AAPL",
      "interval": "D",
      "timezone": "Etc/UTC",
      "theme": "light",
      "style": "1",
      "locale": "en",
      "toolbar_bg": "#f1f3f6",
      "enable_publishing": false,
      "allow_symbol_change": true,
      "container_id": "tradingview-chart"
    }
  );
});

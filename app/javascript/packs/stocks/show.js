import Chart from 'chart.js/auto';

$(document).on('turbolinks:load', function () {
  // Trading View Chart
  var ex_symbol = $('#stockexchange').html()
  var ex_dict = {"NAS":"NASDAQ", "NYS":"NYSE"}
  var exchange = ex_dict[ex_symbol]
  new TradingView.widget(
    {
      "width": 980,
      "height": 610,
      "symbol": exchange.concat(":",document.getElementById('stockname').innerHTML),
      "interval": "D",
      "timezone": "Etc/UTC",
      "theme": "light",
      "style": "1",
      "locale": "en",
      "toolbar_bg": "#f1f3f6",
      "enable_publishing": false,
      "allow_symbol_change": true,
      "container_id": "tradingview_Chart"
  });


  //Get the price predict values
  var price_prediction = $('.price_prediction').data('pxpredict');
  $.each(price_prediction, function() {

    //Prediction Chart
    new Chart($("#line-chart"), {
      type: 'line',
      data: {
        labels: [
          this['nd_date'], this['st_date'], this['mt_date'], this['lt_date']
        ],
        datasets: [{
          data: [
            this['nd_max_price'],
            this['st_max_price'],
            this['mt_max_price'],
            this['lt_max_price']
          ],
          label: "Max",
          borderColor: "#61f29d",
          backgroundColor: "#61f29d",
          fill: true,
          order: 3
        }, {
          data: [
            this['nd_exp_price'],
            this['st_exp_price'],
            this['mt_exp_price'],
            this['lt_exp_price']
          ],
          label: "Expected",
          borderColor: "#8e5ea2",
          backgroundColor: "#8e5ea2",
          fill: true,
          order: 2
        }, {
          data: [
            this['nd_min_price'],
            this['st_min_price'],
            this['mt_min_price'],
            this['lt_min_price']
          ],
          label: "Min",
          borderColor: "#f26370",
          backgroundColor: "#f26370",
          fill: true,
          order: 1
        },
        ]
      },
      options: {
        title: {
          display: true,
          text: 'Expected Returns Prediction'
        }
      }
    });
  });

});

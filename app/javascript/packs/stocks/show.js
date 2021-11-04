import Chart from 'chart.js/auto';

const ALPHA   = '55';
const GREEN   = '#12C91E';
const PURPLE  = '#8E5EA2';
const RED     = '#F26370';
const DIAMOND = 'rectRot';
const PT_SIZE = 2;
const X_AXIS  = {
  MIN: 1,
  MAX: 10,
  MILESTONES: [1, 3, 10]
};

function expPriceData(pd) {
  return {
    data: [
      { x: X_AXIS.MILESTONES[0], y: pd.st_exp_price },
      { x: X_AXIS.MILESTONES[1], y: pd.mt_exp_price },
      { x: X_AXIS.MILESTONES[2], y: pd.lt_exp_price },
    ],
    label: "Close",
    pointStyle: DIAMOND,
    pointBorderWidth: PT_SIZE,
    fill: '+1',
    borderColor: PURPLE,
    backgroundColor: RED + ALPHA,
    pointBackgroundColor: PURPLE,
    order: 2
  };
}

function scaleOptions() {
  return {
    x: {
      type: 'linear',
      display: true,
      ticks: {
        min: X_AXIS.MIN,
        max: X_AXIS.MAX,
        stepSize: 1,
        minRotation: 45,
        callback: function(value, index, values) {
          const dataPoints = X_AXIS.MILESTONES;
          const labels = this.chart.data.labels;
          return labels[dataPoints.indexOf(value)];
        }
      }
    }
  };
}

function tooltipOptions() {
  return {
    titleAlign: 'center',
    bodyAlign: 'center',
    usePointStyle: true,
    callbacks: {
      title: function(context) {
        const dates = context[0].chart.data.labels;
        const terms = ['short term', 'medium term', 'long term'];
        const idx = context[0].dataIndex;
        return `${dates[idx]} (${terms[idx]})`;
      },
      label: function(context) {
        return `${context.dataset.label} Price: ${context.formattedValue}`;
      },
      labelPointStyle: function(context) {
        return { pointStyle: DIAMOND };
      }
    }
  };
}


let chart = null;


$(document).ready(function () {
  // Trading View Chart
  var ex_symbol = $('#stockexchange').html()
  var ex_dict = {"NAS":"NASDAQ", "NYS":"NYSE"}
  var exchange = ex_dict[ex_symbol]
  new TradingView.widget(
    {
      "width": 1300,
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


  // Prediction Chart
  const pd = $('.price_prediction').data('pxpredict');
  const chartData = {
    labels: [ pd.st_date, pd.mt_date, pd.lt_date ],
    datasets: [ expPriceData(pd) ]
  };

  const options = {
    scales: scaleOptions(),
    plugins: {
      legend: {
        display: false,
      },
      tooltip: tooltipOptions()
    }
  };

  chart = new Chart($("#line-chart"), {
    type: 'line',
    data: chartData,
    options: options
  });

  //Set timeout
  setTimeout(function(){
    $('#flash').fadeOut();
    }, 2000);
});

import Chart from 'chart.js/auto';

const ALPHA   = '55';
const GREEN   = '#12C91E';
const PURPLE  = '#8E5EA2';
const RED     = '#F26370';
const DIAMOND = 'rectRot';
const PT_SIZE = 2;
const X_AXIS  = {
  MIN: 1,
  MAX: 365,
  MILESTONES: [1, 14, 90, 365]
};


function maxPriceData(pd) {
  return {
    data: [
      { x: pd.nd_day, y: pd.nd_max_price },
      { x: pd.st_day, y: pd.st_max_price },
      { x: pd.mt_day, y: pd.mt_max_price }
    ],
    label: "Maximum",
    pointStyle: DIAMOND,
    pointBorderWidth: PT_SIZE,
    fill: '+1',
    borderColor: GREEN,
    backgroundColor: GREEN + ALPHA,
    pointBackgroundColor: GREEN,
    order: 3
  };
}

function expPriceData(pd) {
  return {
    data: [
      { x: pd.nd_day, y: pd.nd_exp_price },
      { x: pd.st_day, y: pd.st_exp_price },
      { x: pd.mt_day, y: pd.mt_exp_price },
    ],
    label: "Expected",
    pointStyle: DIAMOND,
    pointBorderWidth: PT_SIZE,
    fill: '+1',
    borderColor: PURPLE,
    backgroundColor: RED + ALPHA,
    pointBackgroundColor: PURPLE,
    order: 2
  };
}

function minPriceData(pd) {
  return {
    data: [
      { x: pd.nd_day, y: pd.nd_min_price },
      { x: pd.st_day, y: pd.st_min_price },
      { x: pd.mt_day, y: pd.mt_min_price },
    ],
    label: "Mininum",
    pointStyle: DIAMOND,
    pointBorderWidth: PT_SIZE,
    borderColor: RED,
    pointBackgroundColor: RED,
    order: 1
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

function legendOptions() {
  return {
    reverse: true,
    labels: {
      font: { size: 20 },
      padding: 10,
      generateLabels: function(chart) {
        const labels = Chart.defaults.plugins.legend.labels.generateLabels(chart);
        labels.forEach(l => l.fillStyle = l.strokeStyle);
        return labels;
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
        const terms = ['next day', 'short term', 'medium term', 'long term'];
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
    labels: [ pd.nd_date, pd.st_date, pd.mt_date ],
    datasets: [ maxPriceData(pd), expPriceData(pd), minPriceData(pd) ]
  };

  const options = {
    scales: scaleOptions(),
    plugins: {
      legend: legendOptions(),
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

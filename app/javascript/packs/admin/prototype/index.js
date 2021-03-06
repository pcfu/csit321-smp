import Alerts from 'common/alerts';
import blink from 'common/blink';
import AdminChannel from 'channels/admin_channel';

let alertsContainer;

$(document).ready(function () {
  alertsContainer = $('#alerts-container');
  setupWebSocket();
  addTrainingClickListeners();
  addPredictionClickListener();
});


function setupWebSocket() {
  const channel = new AdminChannel().subscribe();
  channel.onReceiveCallback(function (data) {
    if (data.subject === 'model_config') {
      handleModelConfigMessage(data);
    } else if (data.subject === 'price_prediction') {
      handlePredictionMessage(data.body);
    }
  });
}

function addTrainingClickListeners() {
  $('#training-button').on('click', function () {
    const stockIds = getTrainingSelections();
    if (stockIds.length <= 0) {
      Alerts.warning(alertsContainer, "Select at least 1 stock for the model to train on");
    } else {
      const data = {
        config_id: 1,
        stock_ids: stockIds,
        // date_start: '2006-01-01',
        // date_end: '2021-12-31',
      };
      sendPostRequest("/admin/model_trainings/batch_enqueue", data);
    }
  });

  $('#cb_all').on('change', function () {
    const checked = $(this).is(':checked');
    $('.model-training-option').prop('checked', checked);
  })
}

function getTrainingSelections() {
  const stockIds = [];

  $('.model-training-option').each(function () {
    const checkbox = $(this);
    if (checkbox.is(':checked')) {
      stockIds.push(checkbox.val());
    };
  });

  return stockIds;
}

function addPredictionClickListener() {
  $('#prediction-button').on('click', function () {
    const data = {
      config_id: 1,
      stock_id: $('input[name="stock_id"]:checked').val(),
    };
    sendPostRequest("/admin/price_predictions/enqueue", data);
  });
}

function sendPostRequest(endpoint, data) {
  $.post(endpoint, data, function(data) {
    if (data.status === 'success') {
      Alerts.success(alertsContainer, data.message);
    } else {
      Alerts.warning(alertsContainer, data.message);
    }

  }).fail(function(xhr, status, error) {
    Alerts.danger(alertsContainer, getErrorMessage(xhr.responseJSON));
  });
}

function getErrorMessage(response) {
  return response ? response.message : "Unknown error occurred";
}


function handleModelConfigMessage(data) {
  if (data.context === 'success') {
    Alerts.success(alertsContainer, data.body.message);
  }
  updateModelConfigTable(data.body.train_percent, data.body.updated_at);
}

function updateModelConfigTable(progress, timestamp) {
  const [_, progCol, tsCol] = $('#model-config-table').find('td');
  $(progCol).html(progress);
  $(tsCol).html(timestamp);
  blink($(progCol).parent());
}


function handlePredictionMessage(data) {
  let rows = $('#predictions-table tbody tr');
  while (rows.length >= 5) {
    rows.last().remove();
    rows = $('#predictions-table tbody tr');
  }

  const newRow = buildRow(data);
  $('#predictions-table tbody').prepend(newRow);
  blink(newRow);

  Alerts.success(alertsContainer, data.message);
}

function buildRow(data) {
  const keys = [
    'symbol', 'entry_date', 'nd_date', 'nd_max_price', 'nd_exp_price',
    'nd_min_price', 'st_date', 'st_max_price', 'st_exp_price', 'st_min_price'
  ];

  const tr = $('<tr>');
  Object.entries(data).forEach(([k, v]) => {
    if (keys.includes(k)) {
      const td = $('<td>')
      td.text(v);
      tr.append(td);
    }
  })
  return tr;
}

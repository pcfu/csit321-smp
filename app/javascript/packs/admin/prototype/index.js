import Alerts from 'common/alerts';
import AdminChannel from 'channels/admin_channel';

let alertsContainer;

$(document).on('turbolinks:load', function () {
  alertsContainer = $('#alerts-container');
  setupWebSocket();
  addTrainingClickListener();
  addPredictionClickListener();
});


function setupWebSocket() {
  const channel = new AdminChannel().subscribe();
  channel.onReceiveCallback(function (data) {
    if (data.subject === 'model_config') {
      handleModelConfigMessage(data);
    }
  });
}

function addTrainingClickListener() {
  $('#training-button').on('click', function () {
    const data = {
      config_id: 1,
      date_start: '2020-01-01',
      date_end: '2021-01-01',
    };
    sendPostRequest("/admin/model_trainings/batch_enqueue", data);
  });
}

function addPredictionClickListener() {
  $('#prediction-button').on('click', function () {
    const data = {
      config_id: 1,
      stock_id: 1,
      date_start: '2021-01-01',
      date_end: '2021-06-01',
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
}

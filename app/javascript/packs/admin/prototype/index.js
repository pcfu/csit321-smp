import Alerts from '../../../common/alerts';

$(document).on('turbolinks:load', function () {
  $('#training-button').on('click', function () {
    const alertsContainer = $('#alerts-container');

    const data = {
      config_id: 1,
      data_range: ['2020-01-01', '2021-01-01']
    };

    $.post('/admin/model_trainings.json', data, function(data) {
      Alerts.success(alertsContainer, data.message);

    }).fail(function(xhr, status, error) {
      Alerts.danger(
        alertsContainer,
        xhr.responseJSON ? xhr.responseJSON.message : "Unknown error occurred"
      );
    });
  })
});

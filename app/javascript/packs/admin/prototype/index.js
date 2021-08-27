import Alerts from '../../../common/alerts';

$(document).on('turbolinks:load', function () {
  $('#training-button').on('click', function () {
    const alertsContainer = $('#alerts-container');

    $.post('/admin/model_trainings', function(data) {
      Alerts.success(alertsContainer, data.message);

    }).fail(function(xhr, status, error) {
      Alerts.danger(alertsContainer, xhr.responseJSON.message);
    });
  })
});

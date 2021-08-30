import Alerts from 'common/alerts';
import AdminChannel from 'channels/admin_channel';


$(document).on('turbolinks:load', function () {
  const channel = new AdminChannel().subscribe();
  channel.onReceiveCallback(function (data) {
    const alertsContainer = $('#alerts-container');
    Alerts[data.context ? data.context : 'primary'](alertsContainer, data.body);
  });

  $('#training-button').on('click', function () {
    const alertsContainer = $('#alerts-container');

    const data = {
      config_id: 1,
      date_start: '2020-01-01',
      date_end: '2021-01-01',
    };

    $.post('/admin/model_trainings/batch_enqueue', data, function(data) {
      Alerts.success(alertsContainer, data.message);

    }).fail(function(xhr, status, error) {
      Alerts.danger(
        alertsContainer,
        xhr.responseJSON ? xhr.responseJSON.message : "Unknown error occurred"
      );
    });
  })
});

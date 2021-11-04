import Alerts from 'common/alerts';
import blink from 'common/blink';
import AdminChannel from 'channels/admin_channel';

let alertsContainer;

function setupWebSocket() {
  const channel = new AdminChannel().subscribe();
  channel.onReceiveCallback(function (data) {
    if (data.subject === 'model training progress') {
      handleModelConfigMessage(data);
    }
  });
}

function handleModelConfigMessage(data) {
  if (data.subject === "model training progress") {
    const model_name = data.model_name;

    if (data.percent > 0) {
      const elem = $(`#${model_name}-train-percent`);
      elem.text(`${data.percent}%`);
      blink(elem.parent());
    }

    if (data.percent === 100) {
      $(`#${model_name}-active-btn`).removeClass('d-none');
      $(`#${model_name}-delete-btn`).removeClass('d-none');
      $(`#${model_name}-train-btn`).addClass('d-none');
      $(`#${model_name}-training-indicator`).addClass('d-none');
      Alerts.success(alertsContainer, `${model_name}: training complete`);
    }
  }
}

function initButtons() {
  $('.btn-train').click(function () {
    if (confirm("Confirm to train this set of parameters")) {
      const data = { config_id: $(this).data('configId') };

      $.post("/admin/model_trainings/batch_enqueue", data, function () {
        location.reload();
      }).fail(function (xhr) {
        Alerts.danger(alertsContainer, xhr.statusText);
      });
    }
  });

  const css = {
    "pointer-events": "inherit",
    "cursor": "not-allowed",
    "opacity": 0.5
  }
  $('.btn-training').css(css);
}


$(document).ready(function () {
  alertsContainer = $('#alerts-container');

  //link to stock show page
  $('#model-list tbody tr').css('cursor', 'pointer');
  $('#model-list tbody tr').on('click', 'td:not(.unclickable)', function () {
      var the_link = $(this).parent().attr("data-link");
      window.location = the_link;
  });

  initButtons();
  setupWebSocket();
});

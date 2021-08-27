export default class Alerts {
  static #buildAlert(context, message) {
    const wrapper = $('<div>', { class: 'mt-3'} );

    const alert = $('<div>', {
      class: `alert alert-${context} alert-dismissible fade show`,
      role: 'alert'
    })

    const closeBtn = $('<button>', {
      'type': 'button',
      'class': 'btn-close',
      'data-bs-dismiss': 'alert',
      'aria-label': 'Close'
    });

    alert.append(message).append(closeBtn);
    return wrapper.append(alert);
  }

  static success(container, message) {
    container.append(Alerts.#buildAlert('success', message));
  }

  static danger(container, message) {
    container.append(Alerts.#buildAlert('danger', message));
  }
}

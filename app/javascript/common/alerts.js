export default class Alerts {
  static #buildAlert(context, message) {
    const alert = $('<div>', {
      class: `alert alert-${context} alert-dismissible fade show mt-3`,
      role: 'alert'
    })

    const closeBtn = $('<button>', {
      'type': 'button',
      'class': 'btn-close',
      'data-bs-dismiss': 'alert',
      'aria-label': 'Close'
    });

    alert.append(message).append(closeBtn);
    return alert;
  }

  static #addAlert(alert, container, maxDisplay) {
    const alerts = container.children()
    if (alerts.length >= maxDisplay) {
      alerts[0].remove();
    }
    container.append(alert);
  }

  static success(container, message, maxDisplay = 3) {
    const alert = Alerts.#buildAlert('success', message);
    Alerts.#addAlert(alert, container, maxDisplay);
  }

  static warning(container, message, maxDisplay = 3) {
    const alert = Alerts.#buildAlert('warning', message);
    Alerts.#addAlert(alert, container, maxDisplay);
  }

  static danger(container, message, maxDisplay = 3) {
    const alert = Alerts.#buildAlert('danger', message);
    Alerts.#addAlert(alert, container, maxDisplay);
  }

  static primary(container, message, maxDisplay = 3) {
    const alert = Alerts.#buildAlert('primary', message);
    Alerts.#addAlert(alert, container, maxDisplay);
  }
}

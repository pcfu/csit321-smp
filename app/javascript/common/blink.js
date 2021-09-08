function blinkElement(e) {
  if (e.hasClass('blinking')) return;

  e.addClass('blinking');

  let timeout = setTimeout(function () {
    e.removeClass('blinking');
    clearTimeout(timeout);
  }, 1000);
}

export default function blink(...elements) {
  elements.forEach(e => blinkElement(e));
}

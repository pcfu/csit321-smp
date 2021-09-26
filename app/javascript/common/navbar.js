const HIDDEN = 'd-none';

let panel;

function handleAvatarClicks() {
  $('#avatar').click(function () {
    if (panel.hasClass(HIDDEN)) {
      panel.removeClass(HIDDEN);
    } else {
      panel.addClass(HIDDEN);
    }
  });
}

function handleDocumentClicks() {
  $(document).click(function(e) {
    if (shouldHidePanel(e, panel)) {
      panel.addClass(HIDDEN);
    }
  });
}

/* Helpers */

function clickedOnAvatar(target) {
  const targetId = target.prop('id');
  return targetId === 'avatar' || targetId === 'user-initials';
}

function clickedOutsideControlPanel(event, panel) {
  const [x, y] = [ event.clientX, event.clientY ];
  const [xMin, yMin] = [ panel.offset().left, panel.offset().top ];
  const xMax = xMin + panel.outerWidth();
  const yMax = yMin + panel.outerHeight();
  return x < xMin || x > xMax || y < yMin || y > yMax;
}

function shouldHidePanel(event, panel) {
  return !panel.hasClass(HIDDEN) &&
         !clickedOnAvatar($(event.target)) &&
         clickedOutsideControlPanel(event, panel);
}


/* Main */

$(document).on('turbolinks:load', function () {
  panel = $('.control-panel');
  handleAvatarClicks();
  handleDocumentClicks();
});

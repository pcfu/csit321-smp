require('styles/sessions/login');

import clearErrorOnChange from 'common/form-error-handling';

$(document).ready(function () {
  $('input.form-control').each(function () {
    clearErrorOnChange($(this));
  });
});

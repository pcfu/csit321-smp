require('styles/users/register');

import clearErrorOnChange from 'common/form-error-handling';

$(document).on('turbolinks:load', function () {
  $('input.form-control').each(function () {
    clearErrorOnChange($(this));
  });
});

function clearInputError(elem) {
  const formGroup = elem.parents('.form-group');
  elem.parent().remove();
  formGroup.append(elem);
}

function clearLabelError(elem) {
  const labelGroup = elem.siblings('.form-label-group');
  const label = labelGroup.find('label');
  labelGroup.empty().append(label);
}

export default function clearErrorOnChange(input) {
  input.change(function () {
    if (input.parent().hasClass('field_with_errors')) {
      clearInputError(input);
      clearLabelError(input);
    }
  });
}

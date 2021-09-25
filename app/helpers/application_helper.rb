module ApplicationHelper
  def form_label_with_error(form, field, model)
    content_tag(:div, class: "form-label-group d-flex justify-content-between") do
      concat(form.label field)
      if model.errors[field].present?
        concat(content_tag(:span, model.errors[field].first))
      end
    end
  end
end

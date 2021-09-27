module ApplicationHelper
  def full_title(page_title = '')
    title = 'EZML'
    title += " | #{page_title.titleize}" if page_title.present?
    title
  end

  def form_label_with_error(form, field, model)
    content_tag(:div, class: "form-label-group d-flex justify-content-between") do
      concat(form.label field)
      if model.errors[field].present?
        concat(content_tag(:span, model.errors[field].first, class: 'field-error-message'))
      end
    end
  end
end

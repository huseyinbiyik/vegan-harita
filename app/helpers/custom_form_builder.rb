class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, label_text = nil, options = {})
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "custom-form-group") do
      label = label(method, label_text, class: "form-label")
      field = super(method, options.merge(class: "form-control text-field"))
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def text_area(method, label_text = nil, options = {})
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "custom-form-group") do
      label = label(method, label_text, class: "form-label")
      field = super(method, options.merge(class: "form-control text-area"))
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def select(method, choices = nil, label_text = nil, options = {}, html_options = {}, &block)
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "custom-form-group") do
      label = label(method, label_text, class: "form-label")
      field = super(method, choices, options, html_options.merge(class: "form-control select-field"), &block)
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def file_field(method, label_text = nil, options = {})
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "form-group") do
      label = label(method, label_text, class: "form-label")
      field = super(method, options.merge(class: "form-control file-field"))
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def collection_select(method, collection, value_method, text_method, label_text = nil, options = {}, html_options = {})
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "custom-form-group") do
      label = label(method, label_text, class: "form-label")
      field = super(method, collection, value_method, text_method, options, html_options.merge(class: "form-control collection-select"))
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {})
  error_message = @object.errors[method].first if @object.errors[method].present?

  @template.content_tag(:div, class: "custom-form-group", data: { controller: "collection-check-boxes" }) do
    label = label(method, options[:label_text], class: "form-label")
    search_bar = @template.text_field_tag("search_#{method}", nil, placeholder: "Search...", class: "form-control search-bar", data: { action: "input->collection-check-boxes#filter" })
    fields = @template.content_tag(:div, class: "checkbox-group", data: { collection_check_boxes_target: "checkboxes" }) do
      collection.map do |item|
        checkbox = @template.check_box_tag("#{object_name}[#{method}][]", item.send(value_method), @object.send(method).include?(item.send(value_method)), html_options.merge(class: "form-control collection-checkbox"))
        checkbox_label = @template.label_tag("#{object_name}_#{method}_#{item.send(value_method)}", item.send(text_method), class: "checkbox-label")
        @template.content_tag(:div, checkbox.concat(checkbox_label), class: "checkbox-item", data: { collection_check_boxes_target: "checkboxItem" })
      end.join.html_safe
    end
    error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

    label.concat(search_bar).concat(fields).concat(error)
  end
end

  def rich_text_area(method, label_text = nil, options = {})
    error_message = @object.errors[method].first if @object.errors[method].present?

    @template.content_tag(:div, class: "custom-form-group") do
      label = label(method, label_text, class: "form-label")
      field = @template.rich_text_area(object_name, method, options.merge(class: "form-control rich-text-area"))
      error = error_message ? @template.content_tag(:span, error_message, class: "red-text") : "".html_safe

      label.concat(field).concat(error)
    end
  end

  def submit(value = nil, options = {})
    @template.content_tag(:div, class: "form-group") do
      super(value, options.merge(class: "submit-button"))
    end
  end
end

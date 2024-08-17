class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    text ||= object.class.human_attribute_name(method)
    super(method, text, options.merge(class: ""), &block)
  end


  def text_field(method, options = {})
    super(method, options.merge(class: "form-control text-field"))
  end

  def text_area(method, options = {})
    super(method, options.merge(class: "form-control text-area"))
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    super(method, choices, options, html_options.merge(class: "form-control select-field"), &block)
  end

  def file_field(method, options = {})
    @template.content_tag(:div, class: "custom-form-group") do
      field = super(method, options.merge(class: "form-control file-field", direct_upload: true))
      span = @template.content_tag(:span, "No file chosen", class: "file-name")
      field.concat(span)
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    super(method, collection, value_method, text_method, options, html_options.merge(class: "form-control collection-select"))
  end

  def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {})
  @template.content_tag(:div, class: "custom-form-group", data: { controller: "collection-check-boxes" }) do
    search_bar = @template.text_field_tag("search_#{method}", nil, placeholder: "Search...", class: "form-control search-bar", data: { action: "input->collection-check-boxes#filter" })
    fields = @template.content_tag(:div, class: "checkbox-group", data: { collection_check_boxes_target: "checkboxes" }) do
      collection.map do |item|
        checkbox = @template.check_box_tag("#{object_name}[#{method}][]", item.send(value_method), @object.send(method).include?(item.send(value_method)), html_options.merge(class: "form-control collection-checkbox"))
        checkbox_label = @template.label_tag("#{object_name}_#{method}_#{item.send(value_method)}", item.send(text_method), class: "checkbox-label")
        @template.content_tag(:div, checkbox.concat(checkbox_label), class: "checkbox-item", data: { collection_check_boxes_target: "checkboxItem" })
      end.join.html_safe
    end

    search_bar.concat(fields)
  end
end

  def rich_text_area(method, options = {})
    @template.rich_text_area(object_name, method, options.merge(class: "form-control rich-text-area"))
  end

  def submit(value = nil, options = {})
    super(value, options.merge(class: "submit-button"))
  end
end

class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    text ||= object.class.human_attribute_name(method)
    @template.content_tag :div, class: "flex" do
      (
        super(method, text, options.merge(class: "form-label")) +
        (options[:required] ? @template.content_tag(:span, "*", class: "red-text") : "")
      ).html_safe
    end
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
      super(method, options.merge(class: "form-control file-field", direct_upload: true))
    end
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    super(method, collection, value_method, text_method, options, html_options.merge(class: "form-control collection-select select-field"))
  end

  def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {})
  @template.content_tag(:div, class: "custom-form-group", data: { controller: "collection-check-boxes" }) do
    search_bar = @template.text_field_tag("search_#{method}", nil, placeholder: @template.t("helpers.placeholder.search"), class: "form-control search-bar", data: { action: "input->collection-check-boxes#filter" })
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

  def checkbox(method, options = {})
    @template.check_box(@object_name, method, options.merge(class: "form-control checkbox"), true, false)
  end

  def rich_text_area(method, options = {})
    @template.rich_text_area(object_name, method, options.merge(class: "form-control rich-text-area"))
  end

  def submit(value = nil, options = {})
    super(value, options.merge(class: "submit-button button"))
  end

  def email_field(method, options = {})
    super(method, options.merge(class: "form-control email.field"))
  end


  def password_field(method, options = {})
    super(method, options.merge(class: "form-control password-field"))
  end

  def number_field(method, options = {})
    super(method, options.merge(class: "form-control number-field"))
  end

  def phone_field(method, options = {})
    super(method, options.merge(class: "form-control phone-field"))
  end

  def div_radio_button(method, tag_value, options = {})
    @template.content_tag(:div,
      @template.radio_button(
        @object_name, method, tag_value, objectify_options(options)
      )
    )
  end

  def hidden_fields(method, options = {})
    @template.hidden_field_tag(field_name, value)
  end

  def search_field(method, options = {})
    super(method, options.merge(class: "form-control search-field"))
  end
end

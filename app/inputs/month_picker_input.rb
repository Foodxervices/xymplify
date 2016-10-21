class MonthPickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:class] << "form-control date_picker"
    input_html_options['data-date-format'] = "yyyy-mm"
    input_html_options['data-date-viewmode'] = "years"
    input_html_options['data-date-minviewmode'] = "months"
    @builder.text_field(attribute_name, input_html_options)
  end
end

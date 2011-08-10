ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag.include? 'label'
    if instance.error_message.kind_of?(Array)
      %(<p class="validation-error">#{instance.error_message.first}</p>#{html_tag}).html_safe
    else
      %(<p class="validation-error">#{instance.error_message}</p>#{html_tag}).html_safe
    end
  end
end 

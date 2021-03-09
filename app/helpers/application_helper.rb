module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success'
      'alert-primary'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-danger'
    when 'notice'
      'alert-primary'
    else
      flash_type.to_s
    end
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}") do
        # concat content_tag(:button, fa_icon('times-circle'), class: 'close', data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end
end

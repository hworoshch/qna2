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
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}") { concat message })
    end
    nil
  end

  def collection_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end

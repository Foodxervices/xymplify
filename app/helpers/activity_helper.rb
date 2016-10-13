module ActivityHelper
  def activity_message(activity) 
    kclass = activity.item_type.constantize
    
    user_link = link_to_if(can?(:show, activity.user), activity.user.name, user_path(activity.user), remote: true) if activity.user

    event = activity.event == "destroy" ? "deleted" : "#{activity.event}d"

    if activity.item.nil?
      item_link = activity.reify.name if activity.reify.present?
    else
      if ['OrderItem', 'OrderGst'].include?(activity.item_type)
        item_link = link_to_if(can?(:read, activity.item.order), activity.item&.name, activity.item.order, remote: true)  
      else
        item_link = link_to_if(can?(:read, activity.item), activity.item&.name, activity.item, remote: true) if activity.item 
      end
    end
    
    "#{user_link} #{event} #{kclass.model_name.human} #{item_link} #{time_ago_in_words(activity.created_at)} ago".html_safe
  end
end

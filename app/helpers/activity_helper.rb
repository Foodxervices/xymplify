module ActivityHelper
  def activity_message(activity) 
    user_link = link_to_if(can?(:show, activity.user), activity.user.name, user_path(activity.user), remote: true)

    event = activity.event == "destroy" ? "deleted" : "#{activity.event}d"

    if activity.item.nil?
      item_link = activity.reify.name if activity.reify.present?
    else
      item_link = link_to_if(can?(:read, activity.item), activity.item.name, activity.item, remote: true)  
    end
    
    "#{user_link} #{event} #{item_link} #{time_ago_in_words(activity.created_at)} ago".html_safe
  end
end
